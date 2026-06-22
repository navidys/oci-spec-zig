const std = @import("std");
const utils = @import("../utils.zig");
const ocispec = @import("ocispec");
const image = ocispec.image;
const testing = std.testing;

test "image index" {
    const allocator = testing.allocator;

    const index_filename = "index.json";
    const index1_file_path = try std.mem.concat(
        allocator,
        u8,
        &.{ "./tests/fixtures/", index_filename },
    );

    defer allocator.free(index1_file_path);

    const index1 = try image.Index.initFromFile(allocator, index1_file_path);
    defer index1.deinit();

    const index1_manifest = index1.value.manifests;

    try testing.expectEqual(index1.value.schemaVersion, 2);
    try testing.expectEqual(index1.value.mediaType, image.MediaType.ImageIndex);
    try testing.expectEqual(index1_manifest.len, 2);
    try testing.expectEqual(index1_manifest[0].mediaType, image.MediaType.ImageManifest);
    try testing.expectEqual(index1_manifest[0].size, 7143);
    try testing.expectEqual(index1_manifest[0].digest.algorithm, image.DigestAlgorithm.Sha256);
    try testing.expectEqualStrings(index1_manifest[0].digest.value, "e692418e4cbaf90ca69d05a66403747baa33ee08806650b51fab815ad7fc331f");
    try testing.expectEqual(index1_manifest[0].platform.?.architecture, image.Arch.PowerPC64le);
    try testing.expectEqual(index1_manifest[0].platform.?.os, image.OS.Linux);

    // try to write json pretty to new file and compare to original file
    const index1_string_pretty = try index1.value.toStringPretty(allocator);
    defer allocator.free(index1_string_pretty);

    const index2_file_path = try std.mem.concat(
        allocator,
        u8,
        &.{ utils.TEST_DATA_DIR, "/", index_filename },
    );

    defer allocator.free(index2_file_path);

    try utils.writeFileContent(index2_file_path, index1_string_pretty);

    var cwd = std.Io.Dir.cwd();

    const index1_file = try cwd.openFile(testing.io, index1_file_path, .{});
    defer index1_file.close(testing.io);

    const index2_file = try cwd.openFile(testing.io, index2_file_path, .{});
    defer index2_file.close(testing.io);

    const index1_file_stat = try index1_file.stat(testing.io);
    const index2_file_stat = try index2_file.stat(testing.io);

    try testing.expectEqual(index1_file_stat.size, index2_file_stat.size + 1);
}
