const std = @import("std");
const utils = @import("../utils.zig");
const ocispec = @import("oci-spec");
const image = ocispec.image;

test "image oci layout" {
    const oci_layout_filename = "oci_layout.json";
    const oci_layout1_file_path = try std.mem.concat(
        std.heap.page_allocator,
        u8,
        &.{ "./tests/fixtures/", oci_layout_filename },
    );
    const oci_layout1 = try image.OciLayout.initFromFile(oci_layout1_file_path);
    const oci_layout1_string = try oci_layout1.toString();

    try std.testing.expect(std.mem.eql(
        u8,
        oci_layout1.imageLayoutVersion,
        "1.0.0",
    ) == true);

    try std.testing.expect(std.mem.eql(
        u8,
        oci_layout1_string,
        "{\"imageLayoutVersion\":\"1.0.0\"}",
    ) == true);

    // try to write json pretty to new file and compare to original file
    const oci_layout1_string_pretty = try oci_layout1.toStringPretty();
    const oci_layout1_string_pretty_new_line = try std.mem.concat(
        std.heap.page_allocator,
        u8,
        &.{ oci_layout1_string_pretty, "\n" },
    );
    const oci_layout2_file_path = try std.mem.concat(
        std.heap.page_allocator,
        u8,
        &.{ utils.TEST_DATA_DIR, "/", oci_layout_filename },
    );

    try utils.writeFileContent(oci_layout2_file_path, oci_layout1_string_pretty_new_line);

    const oci_layout1_file = try std.fs.cwd().openFile(oci_layout1_file_path, .{});
    defer oci_layout1_file.close();

    const oci_layout2_file = try std.fs.cwd().openFile(oci_layout2_file_path, .{});
    defer oci_layout2_file.close();

    const oci_layout1_file_stat = try oci_layout1_file.stat();
    const oci_layout2_file_stat = try oci_layout2_file.stat();

    try std.testing.expectEqual(oci_layout1_file_stat.size, oci_layout2_file_stat.size);
}
