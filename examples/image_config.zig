const std = @import("std");
const ocispec = @import("oci-spec");
const image = ocispec.image;

pub fn main() !void {
    const file_path = "./tests/fixtures/config.json";
    const image_config = try image.Configuration.initFromFile(file_path);
    const config_content = try image_config.toStringPretty();

    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    const stdout = bw.writer();

    try stdout.print("{s}\n", .{config_content});

    try bw.flush();
}
