const std = @import("std");
const utils = @import("../utils.zig");
const ocispec = @import("ocispec");
const image = ocispec.image;
const testing = std.testing;

test "image oci layout" {
    const allocator = testing.allocator;

    const oci_layout_filename = "oci_layout.json";
    const oci_layout1_file_path = try std.mem.concat(
        allocator,
        u8,
        &.{ "./tests/fixtures/", oci_layout_filename },
    );

    defer allocator.free(oci_layout1_file_path);

    const oci_layout1 = try image.OciLayout.initFromFile(allocator, oci_layout1_file_path);
    defer oci_layout1.deinit();

    const oci_layout1_string = try oci_layout1.value.toString(allocator);
    defer allocator.free(oci_layout1_string);

    try testing.expectEqualStrings(oci_layout1.value.imageLayoutVersion, "1.0.0");
    try testing.expectEqualStrings(oci_layout1_string, "{\"imageLayoutVersion\":\"1.0.0\"}");

    // try to write json pretty to new file and compare to original file
    const oci_layout1_string_pretty = try oci_layout1.value.toStringPretty(allocator);
    defer allocator.free(oci_layout1_string_pretty);

    const oci_layout2_file_path = try std.mem.concat(
        allocator,
        u8,
        &.{ utils.TEST_DATA_DIR, "/", oci_layout_filename },
    );

    defer allocator.free(oci_layout2_file_path);

    try utils.writeFileContent(oci_layout2_file_path, oci_layout1_string_pretty);

    var cwd = std.Io.Dir.cwd();

    const oci_layout1_file = try cwd.openFile(testing.io, oci_layout1_file_path, .{});
    defer oci_layout1_file.close(testing.io);

    const oci_layout2_file = try cwd.openFile(testing.io, oci_layout2_file_path, .{});
    defer oci_layout2_file.close(testing.io);

    const oci_layout1_file_stat = try oci_layout1_file.stat(testing.io);
    const oci_layout2_file_stat = try oci_layout2_file.stat(testing.io);

    try testing.expectEqual(oci_layout1_file_stat.size, oci_layout2_file_stat.size + 1);
}
