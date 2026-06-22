const std = @import("std");
const ocispec = @import("ocispec");
const runtime = ocispec.runtime;

pub fn main(init: std.process.Init) !void {
    const allocator = init.arena.allocator();

    const file_path = "./tests/fixtures/runtime_spec.json";
    const spec = try runtime.Spec.initFromFile(allocator, file_path);
    defer spec.deinit();

    const config_content = try spec.value.toStringPretty(allocator);
    defer allocator.free(config_content);

    var write_buf: [4096]u8 = undefined;

    var stdout_wrtiter = std.Io.File.stdout().writer(init.io, &write_buf);
    const stdout = &stdout_wrtiter.interface;

    try stdout.print("{s}\n", .{config_content});
    stdout.flush() catch {};
}
