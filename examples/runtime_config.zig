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

    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    const stdout = bw.writer();

    try stdout.print("{s}\n", .{config_content});

    try bw.flush();
}
