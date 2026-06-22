const std = @import("std");
const utils = @import("../utils.zig");
const ocispec = @import("ocispec");
const image = ocispec.image;
const testing = std.testing;

test "image manifest" {
    const allocator = testing.allocator;

    const manifet_filename = "manifest.json";
    const manifest1_file_path = try std.mem.concat(
        allocator,
        u8,
        &.{ "./tests/fixtures/", manifet_filename },
    );

    defer allocator.free(manifest1_file_path);

    const manifest1 = try image.Manifest.initFromFile(allocator, manifest1_file_path);
    defer manifest1.deinit();

    const manifest1_subject = manifest1.value.subject;

    try testing.expectEqual(manifest1.value.schemaVersion, 2);
    try testing.expectEqual(manifest1.value.mediaType, image.MediaType.ImageManifest);
    try testing.expectEqual(manifest1.value.config.size, 7023);
    try testing.expectEqual(manifest1.value.layers.len, 3);
    try testing.expect(manifest1_subject.?.mediaType == image.MediaType.ImageManifest);
    try testing.expect(manifest1_subject.?.size == 7682);

    // try to write json pretty to new file and compare to original file
    const manifest1_string_pretty = try manifest1.value.toStringPretty(allocator);
    defer allocator.free(manifest1_string_pretty);

    const manifest2_file_path = try std.mem.concat(
        allocator,
        u8,
        &.{ utils.TEST_DATA_DIR, "/", manifet_filename },
    );
    defer allocator.free(manifest2_file_path);

    try utils.writeFileContent(manifest2_file_path, manifest1_string_pretty);

    var cwd = std.Io.Dir.cwd();

    const manifest1_file = try cwd.openFile(testing.io, manifest1_file_path, .{});
    defer manifest1_file.close(testing.io);

    const manifest2_file = try cwd.openFile(testing.io, manifest2_file_path, .{});
    defer manifest2_file.close(testing.io);

    const manifest1_file_stat = try manifest1_file.stat(testing.io);
    const manifest2_file_stat = try manifest2_file.stat(testing.io);

    try testing.expectEqual(manifest1_file_stat.size, manifest2_file_stat.size + 1);
}
