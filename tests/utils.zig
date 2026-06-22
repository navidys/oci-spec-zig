const std = @import("std");
const fs = std.fs;

pub const TEST_DATA_DIR = "./test-out";

pub fn writeFileContent(file_path: []const u8, content: []const u8) !void {
    const cwd = std.Io.Dir.cwd();

    cwd.createDir(std.testing.io, TEST_DATA_DIR, std.Io.Dir.Permissions.default_dir) catch |e|
        switch (e) {
            error.PathAlreadyExists => {},
            else => return e,
        };

    const file = try cwd.createFile(std.testing.io, file_path, .{ .read = false });

    defer file.close(std.testing.io);

    _ = try file.writeStreamingAll(std.testing.io, content);
}
