const std = @import("std");
const ocispec = @import("oci-spec");
const runtime = ocispec.runtime;

pub fn main() !void {
    const file_path = "./tests/fixtures/spec.json";
    const spec = try runtime.Spec.initFromFile(file_path);

    const config_content = try spec.toStringPretty();

    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    const stdout = bw.writer();

    try stdout.print("{s}\n", .{config_content});

    try bw.flush();
}
