const std = @import("std");
const fs = std.fs;

/// reads content of a given file path
pub fn readFileContent(file_path: []const u8, allocator: std.mem.Allocator) ![]u8 {
    const file = try std.fs.cwd().openFile(file_path, fs.File.OpenFlags{ .mode = .read_only });
    defer file.close();

    const file_size = try file.getEndPos();

    const buffer = try allocator.alloc(u8, file_size);

    _ = try file.readAll(buffer);

    return buffer;
}

pub fn writeFileContent(file_path: []const u8, content: []const u8) !void {
    const content_newline = try std.mem.concat(
        std.heap.page_allocator,
        u8,
        &.{ content, "\n" },
    );

    const file = try std.fs.cwd().createFile(file_path, fs.File.CreateFlags{ .read = false });

    defer file.close();

    _ = try file.writeAll(content_newline);
}

pub fn toJsonString(value: anytype, pretty: bool) ![]const u8 {
    const allocator = std.heap.page_allocator;

    const jsonValue = switch (pretty) {
        true => try std.json.stringifyAlloc(
            allocator,
            value,
            .{ .emit_strings_as_arrays = false, .emit_null_optional_fields = false, .whitespace = .indent_4 },
        ),
        false => try std.json.stringifyAlloc(
            allocator,
            value,
            .{ .emit_strings_as_arrays = false, .emit_null_optional_fields = false },
        ),
    };

    return jsonValue;
}
