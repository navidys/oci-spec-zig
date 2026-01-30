const std = @import("std");
const utils = @import("../utils.zig");
const ocispec = @import("ocispec");
const image = ocispec.image;

test "image config" {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();

    const config_filename = "config.json";
    const config1_file_path = try std.mem.concat(
        allocator,
        u8,
        &.{ "./tests/fixtures/", config_filename },
    );
    const config1 = try image.Configuration.initFromFile(allocator, config1_file_path);

    try std.testing.expectEqualSlices(u8, config1.created, "2015-10-31T22:22:56.015925234Z");
    try std.testing.expectEqualSlices(u8, config1.author.?, "Alyssa P. Hacker <alyspdev@example.com>");
    try std.testing.expectEqual(config1.architecture, image.Arch.Amd64);
    try std.testing.expectEqual(config1.os, image.OS.Linux);
    try std.testing.expectEqualSlices(u8, config1.config.?.User.?, "alice");

    // try to write json pretty to new file and compare to original file
    const config1_string_pretty = try config1.toStringPretty(allocator);

    const config2_file_path = try std.mem.concat(
        allocator,
        u8,
        &.{ utils.TEST_DATA_DIR, "/", config_filename },
    );

    try utils.writeFileContent(config2_file_path, config1_string_pretty);

    const config1_file = try std.fs.cwd().openFile(config1_file_path, .{});
    defer config1_file.close();

    const config2_file = try std.fs.cwd().openFile(config2_file_path, .{});
    defer config2_file.close();

    const config1_file_stat = try config1_file.stat();
    const config2_file_stat = try config2_file.stat();

    try std.testing.expectEqual(config1_file_stat.size, config2_file_stat.size + 1);
}
