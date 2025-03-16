const std = @import("std");
const ocispec = @import("oci-spec");
const image = ocispec.image;

pub fn main() !void {
    const manifest_platform = image.Platform{
        .architecture = image.Arch.PowerPC64,
        .os = image.OS.Linux,
    };

    const index_manifest = image.Descriptor{
        .mediaType = image.MediaType.ImageManifest,
        .size = 32654,
        .platform = manifest_platform,
        .digest = try image.Digest.initFromString("sha256:9834876dcfb05cb167a5c24953eba58c4ac89b1adf57f28f2f9d09af107ee8f0"),
    };

    var manifests = std.ArrayList(image.Descriptor).init(std.heap.page_allocator);

    try manifests.append(index_manifest);

    const image_manifests: []image.Descriptor = try manifests.toOwnedSlice();

    const image_index = image.Index{
        .mediaType = image.MediaType.ImageIndex,
        .manifests = image_manifests,
    };

    const image_index_content = try image_index.toStringPretty();

    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    const stdout = bw.writer();

    try stdout.print("{s}\n", .{image_index_content});

    try bw.flush();
}
