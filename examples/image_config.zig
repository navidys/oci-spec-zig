const std = @import("std");
const ocispec = @import("ocispec");
const image = ocispec.image;

pub fn main(init: std.process.Init) !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();

    const file_path = "./tests/fixtures/config.json";

    const image_config = try image.Configuration.initFromFile(allocator, file_path);
    defer image_config.deinit();

    const config_content = try image_config.value.toStringPretty(allocator);
    defer allocator.free(config_content);

    var write_buf: [4096]u8 = undefined;

    var stdout_wrtiter = std.Io.File.stdout().writer(init.io, &write_buf);
    const stdout = &stdout_wrtiter.interface;

    try stdout.print("{s}\n", .{config_content});
    stdout.flush() catch {};
}
