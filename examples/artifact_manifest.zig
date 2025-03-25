const std = @import("std");
const ocispec = @import("ocispec");
const image = ocispec.image;

pub fn main() !void {
    const file_path = "./tests/fixtures/artifact_manifest.json";
    const artifact_manifest = try image.ArtifactManifest.initFromFile(file_path);

    const config_content = try artifact_manifest.toStringPretty();

    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    const stdout = bw.writer();

    try stdout.print("{s}\n", .{config_content});

    try bw.flush();
}
