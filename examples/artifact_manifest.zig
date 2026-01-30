const std = @import("std");
const ocispec = @import("ocispec");
const image = ocispec.image;

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();

    const file_path = "./tests/fixtures/artifact_manifest.json";
    const artifact_manifest = try image.ArtifactManifest.initFromFile(allocator, file_path);

    const config_content = try artifact_manifest.toStringPretty(allocator);

    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    const stdout = bw.writer();

    try stdout.print("{s}\n", .{config_content});

    try bw.flush();
}
