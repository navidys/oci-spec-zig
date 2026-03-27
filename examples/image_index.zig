const std = @import("std");
const ocispec = @import("ocispec");
const image = ocispec.image;

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();

    const manifest_platform = image.Platform{
        .architecture = image.Arch.PowerPC64,
        .os = image.OS.Linux,
    };

    const index_manifest = image.Descriptor{
        .mediaType = image.MediaType.ImageManifest,
        .size = 32654,
        .platform = manifest_platform,
        .digest = try image.Digest.initFromString(allocator, "sha256:9834876dcfb05cb167a5c24953eba58c4ac89b1adf57f28f2f9d09af107ee8f0"),
    };

    var manifests: std.ArrayListUnmanaged(image.Descriptor) = .{};

    try manifests.append(allocator, index_manifest);

    const image_manifests: []image.Descriptor = try manifests.toOwnedSlice(allocator);

    const image_index = image.Index{
        .mediaType = image.MediaType.ImageIndex,
        .manifests = image_manifests,
    };

    const image_index_content = try image_index.toStringPretty(allocator);

    var write_buf: [4096]u8 = undefined;
    var stdout = std.fs.File.stdout().writer(&write_buf);
    try stdout.interface.print("{s}\n", .{image_index_content});
    stdout.interface.flush() catch {};

}
