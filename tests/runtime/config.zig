const std = @import("std");
const utils = @import("../utils.zig");
const ocispec = @import("ocispec");
const runtime = ocispec.runtime;
const testing = std.testing;

test "runtime config" {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();

    const ruuntimeFile = "runtime_spec.json";
    const ruuntimeFile_path = try std.mem.concat(
        allocator,
        u8,
        &.{ "./tests/fixtures/", ruuntimeFile },
    );
    const spec = try runtime.Spec.initFromFile(allocator, ruuntimeFile_path);

    try testing.expectEqualStrings(spec.ociVersion, "0.5.0-dev");
}
