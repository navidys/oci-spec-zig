const std = @import("std");
const Allocator = std.mem.Allocator;
const fs = std.fs;

/// reads content of a given file path
pub fn readFileContent(allocator: Allocator, file_path: []const u8) ![]u8 {
    const cwd = std.Io.Dir.cwd();

    var writer_thread = std.Io.Threaded.init(allocator, .{});
    defer writer_thread.deinit();

    const io = writer_thread.io();

    const file = try cwd.openFile(io, file_path, .{ .mode = .read_only });
    defer file.close(io);

    var file_reader = file.reader(io, &.{});

    const content = try file_reader.interface.allocRemaining(allocator, .unlimited);

    return content;
}

pub fn writeFileContent(allocator: Allocator, file_path: []const u8, content: []const u8) !void {
    const content_newline = try std.mem.concat(
        allocator,
        u8,
        &.{ content, "\n" },
    );

    var writer_thread = std.Io.Threaded.init(allocator, .{});
    defer writer_thread.deinit();

    const io = writer_thread.io();
    const cwd = std.Io.Dir.cwd();

    const file = try cwd.createFile(io, file_path, fs.File.CreateFlags{ .read = false });

    defer file.close(io);

    _ = try file.writeStreamingAll(io, content_newline);
}

pub fn toJsonString(allocator: Allocator, value: anytype, pretty: bool) ![]const u8 {
    const options: std.json.Stringify.Options = if (pretty)
        .{ .emit_strings_as_arrays = false, .emit_null_optional_fields = false, .whitespace = .indent_4 }
    else
        .{ .emit_strings_as_arrays = false, .emit_null_optional_fields = false };

    return std.json.Stringify.valueAlloc(allocator, value, options);
}
