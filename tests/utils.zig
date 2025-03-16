const std = @import("std");
const fs = std.fs;

pub const TEST_DATA_DIR = "./test-out";

pub fn writeFileContent(file_path: []const u8, content: []const u8) !void {
    fs.cwd().makeDir(TEST_DATA_DIR) catch |e|
        switch (e) {
        error.PathAlreadyExists => {},
        else => return e,
    };

    const file = try std.fs.cwd().createFile(file_path, fs.File.CreateFlags{ .read = false });

    defer file.close();

    _ = try file.writeAll(content);
}
