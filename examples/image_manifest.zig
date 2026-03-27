const std = @import("std");
const ocispec = @import("ocispec");
const image = ocispec.image;

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();

    const media_manifest = image.MediaType.ImageManifest;
    const media_config = image.MediaType.ImageConfig;
    const media_layer = image.MediaType.ImageLayerGzip;

    var mlayers: std.ArrayListUnmanaged(image.Descriptor) = .{};
    try mlayers.append(allocator, image.Descriptor{
        .mediaType = media_layer,
        .digest = try image.Digest.initFromString(
            allocator,
            "sha256:9834876dcfb05cb167a5c24953eba58c4ac89b1adf57f28f2f9d09af107ee8f",
        ),
        .size = 32654,
    });

    const manifest_layers: []image.Descriptor = try mlayers.toOwnedSlice(allocator);

    const manifest = image.Manifest{
        .mediaType = media_manifest,
        .config = image.Descriptor{
            .mediaType = media_config,
            .digest = try image.Digest.initFromString(
                allocator,
                "sha256:b5b2b2c507a0944348e0303114d8d93aaaa081732b86451d9bce1f432a537bc7",
            ),
            .size = 7023,
        },
        .layers = manifest_layers,
    };

    const manifest_content = try manifest.toStringPretty(allocator);

    var write_buf: [4096]u8 = undefined;
    var stdout = std.fs.File.stdout().writer(&write_buf);
    try stdout.interface.print("{s}\n", .{manifest_content});
    stdout.interface.flush() catch {};

}
