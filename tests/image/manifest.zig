const std = @import("std");
const utils = @import("../utils.zig");
const ocispec = @import("ocispec");
const image = ocispec.image;

test "image manifest" {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();

    const manifet_filename = "manifest.json";
    const manifest1_file_path = try std.mem.concat(
        allocator,
        u8,
        &.{ "./tests/fixtures/", manifet_filename },
    );
    const manifest1 = try image.Manifest.initFromFile(allocator, manifest1_file_path);
    const manifest1_subject = manifest1.subject;

    try std.testing.expectEqual(manifest1.schemaVersion, 2);
    try std.testing.expectEqual(manifest1.mediaType, image.MediaType.ImageManifest);
    try std.testing.expectEqual(manifest1.config.size, 7023);
    try std.testing.expectEqual(manifest1.layers.len, 3);
    try std.testing.expect(manifest1_subject.?.mediaType == image.MediaType.ImageManifest);
    try std.testing.expect(manifest1_subject.?.size == 7682);

    // try to write json pretty to new file and compare to original file
    const manifest1_string_pretty = try manifest1.toStringPretty(allocator);

    const manifest2_file_path = try std.mem.concat(
        allocator,
        u8,
        &.{ utils.TEST_DATA_DIR, "/", manifet_filename },
    );

    try utils.writeFileContent(manifest2_file_path, manifest1_string_pretty);

    const manifest1_file = try std.fs.cwd().openFile(manifest1_file_path, .{});
    defer manifest1_file.close();

    const manifest2_file = try std.fs.cwd().openFile(manifest2_file_path, .{});
    defer manifest2_file.close();

    const manifest1_file_stat = try manifest1_file.stat();
    const manifest2_file_stat = try manifest2_file.stat();

    try std.testing.expectEqual(manifest1_file_stat.size, manifest2_file_stat.size + 1);
}
