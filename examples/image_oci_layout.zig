const std = @import("std");
const ocispec = @import("ocispec");
const image = ocispec.image;

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();

    const oci_layout = image.OciLayout{};

    const oci_layout_content = try oci_layout.toStringPretty(allocator);

    var write_buf: [4096]u8 = undefined;
    var stdout = std.fs.File.stdout().writer(&write_buf);
    try stdout.interface.print("{s}\n", .{oci_layout_content});
    stdout.interface.flush() catch {};

}
