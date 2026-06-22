const std = @import("std");
const ocispec = @import("ocispec");
const image = ocispec.image;

pub fn main(init: std.process.Init) !void {
    const allocator = init.arena.allocator();

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

    var manifests: std.ArrayListUnmanaged(image.Descriptor) = .empty;

    try manifests.append(allocator, index_manifest);

    const image_manifests: []image.Descriptor = try manifests.toOwnedSlice(allocator);
    defer allocator.free(image_manifests);

    const image_index = image.Index{
        .mediaType = image.MediaType.ImageIndex,
        .manifests = image_manifests,
    };

    const image_index_content = try image_index.toStringPretty(allocator);
    defer allocator.free(image_index_content);

    var write_buf: [4096]u8 = undefined;

    var stdout_wrtiter = std.Io.File.stdout().writer(init.io, &write_buf);
    const stdout = &stdout_wrtiter.interface;

    try stdout.print("{s}\n", .{image_index_content});
    stdout.flush() catch {};
}
