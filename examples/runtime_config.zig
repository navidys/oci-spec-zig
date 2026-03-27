const std = @import("std");
const ocispec = @import("ocispec");
const runtime = ocispec.runtime;

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();

    const file_path = "./tests/fixtures/runtime_spec.json";
    const spec = try runtime.Spec.initFromFile(allocator, file_path);

    const config_content = try spec.toStringPretty(allocator);

    var write_buf: [4096]u8 = undefined;
    var stdout = std.fs.File.stdout().writer(&write_buf);
    try stdout.interface.print("{s}\n", .{config_content});
    stdout.interface.flush() catch {};

}
