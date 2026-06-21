const std = @import("std");
const utils = @import("../utils.zig");
const ocispec = @import("ocispec");
const image = ocispec.image;
const testing = std.testing;

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
    defer config1.deinit();

    try testing.expectEqualStrings(config1.value.created, "2015-10-31T22:22:56.015925234Z");
    try testing.expectEqualStrings(config1.value.author.?, "Alyssa P. Hacker <alyspdev@example.com>");
    try testing.expectEqual(config1.value.architecture, image.Arch.Amd64);
    try testing.expectEqual(config1.value.os, image.OS.Linux);
    try testing.expectEqualStrings(config1.value.config.?.User.?, "alice");

    // try to write json pretty to new file and compare to original file
    const config1_string_pretty = try config1.value.toStringPretty(allocator);

    const config2_file_path = try std.mem.concat(
        allocator,
        u8,
        &.{ utils.TEST_DATA_DIR, "/", config_filename },
    );

    try utils.writeFileContent(config2_file_path, config1_string_pretty);

    const cwd = std.Io.Dir.cwd();

    const config1_file = try cwd.openFile(testing.io, config1_file_path, .{});
    defer config1_file.close(testing.io);

    const config2_file = try cwd.openFile(testing.io, config2_file_path, .{});
    defer config2_file.close(testing.io);

    const config1_file_stat = try config1_file.stat(testing.io);
    const config2_file_stat = try config2_file.stat(testing.io);

    try testing.expectEqual(config1_file_stat.size, config2_file_stat.size + 1);
}
