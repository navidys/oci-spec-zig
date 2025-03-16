const std = @import("std");
const ocispec = @import("oci-spec");
const image = ocispec.image;

pub fn main() !void {
    const oci_layout = image.OciLayout{};

    const oci_layout_content = try oci_layout.toStringPretty();

    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    const stdout = bw.writer();

    try stdout.print("{s}\n", .{oci_layout_content});

    try bw.flush();
}
