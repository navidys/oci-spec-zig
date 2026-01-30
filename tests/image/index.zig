const std = @import("std");
const utils = @import("../utils.zig");
const ocispec = @import("ocispec");
const image = ocispec.image;

test "image index" {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();

    const index_filename = "index.json";
    const index1_file_path = try std.mem.concat(
        allocator,
        u8,
        &.{ "./tests/fixtures/", index_filename },
    );
    const index1 = try image.Index.initFromFile(allocator, index1_file_path);
    const index1_manifest = index1.manifests;

    try std.testing.expectEqual(index1.schemaVersion, 2);
    try std.testing.expectEqual(index1.mediaType, image.MediaType.ImageIndex);
    try std.testing.expectEqual(index1_manifest.len, 2);
    try std.testing.expectEqual(index1_manifest[0].mediaType, image.MediaType.ImageManifest);
    try std.testing.expectEqual(index1_manifest[0].size, 7143);
    try std.testing.expectEqual(index1_manifest[0].digest.algorithm, image.DigestAlgorithm.Sha256);
    try std.testing.expect(std.mem.eql(
        u8,
        index1_manifest[0].digest.value,
        "e692418e4cbaf90ca69d05a66403747baa33ee08806650b51fab815ad7fc331f",
    ) == true);
    try std.testing.expectEqual(index1_manifest[0].platform.?.architecture, image.Arch.PowerPC64le);
    try std.testing.expectEqual(index1_manifest[0].platform.?.os, image.OS.Linux);

    // try to write json pretty to new file and compare to original file
    const index1_string_pretty = try index1.toStringPretty(allocator);

    const index2_file_path = try std.mem.concat(
        allocator,
        u8,
        &.{ utils.TEST_DATA_DIR, "/", index_filename },
    );

    try utils.writeFileContent(index2_file_path, index1_string_pretty);

    const index1_file = try std.fs.cwd().openFile(index1_file_path, .{});
    defer index1_file.close();

    const index2_file = try std.fs.cwd().openFile(index2_file_path, .{});
    defer index2_file.close();

    const index1_file_stat = try index1_file.stat();
    const index2_file_stat = try index2_file.stat();

    try std.testing.expectEqual(index1_file_stat.size, index2_file_stat.size + 1);
}
