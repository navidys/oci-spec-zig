const std = @import("std");
const ocispec = @import("ocispec");
const image = ocispec.image;

pub fn main(init: std.process.Init) !void {
    const allocator = init.arena.allocator();

    const oci_layout = image.OciLayout{};

    const oci_layout_content = try oci_layout.toStringPretty(allocator);
    defer allocator.free(oci_layout_content);

    var write_buf: [4096]u8 = undefined;

    var stdout_wrtiter = std.Io.File.stdout().writer(init.io, &write_buf);
    const stdout = &stdout_wrtiter.interface;

    try stdout.print("{s}\n", .{oci_layout_content});
    stdout.flush() catch {};
}
