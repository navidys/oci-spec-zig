const std = @import("std");
const ocispec = @import("ocispec");
const zosnsType = ocispec.runtime.ZosNamespaceType;
const testing = std.testing;

test "runtime ZosNamespaceType jsonParse" {
    // Mount
    var nsMount = std.json.Scanner.initCompleteInput(
        testing.allocator,
        "\"mount\"",
    );

    defer nsMount.deinit();

    const nsActMount = try zosnsType.jsonParse(testing.allocator, &nsMount, .{});

    // Uts
    var nsUts = std.json.Scanner.initCompleteInput(
        testing.allocator,
        "\"uts\"",
    );

    defer nsUts.deinit();

    const nsActUtc = try zosnsType.jsonParse(testing.allocator, &nsUts, .{});

    // Ipc
    var nsIpc = std.json.Scanner.initCompleteInput(
        testing.allocator,
        "\"ipc\"",
    );

    defer nsIpc.deinit();

    const nsActIpc = try zosnsType.jsonParse(testing.allocator, &nsIpc, .{});

    // Pid
    var nsPid = std.json.Scanner.initCompleteInput(
        testing.allocator,
        "\"pid\"",
    );

    defer nsPid.deinit();

    const nsActPid = try zosnsType.jsonParse(testing.allocator, &nsPid, .{});

    // tests
    try testing.expectEqual(zosnsType.Mount, nsActMount);
    try testing.expectEqual(zosnsType.Uts, nsActUtc);
    try testing.expectEqual(zosnsType.Ipc, nsActIpc);
    try testing.expectEqual(zosnsType.Pid, nsActPid);
}

test "runtime ZosNamespaceType jsonStringify" {
    // Mount
    var nsMount: std.Io.Writer.Allocating = .init(testing.allocator);
    defer nsMount.deinit();

    try zosnsType.jsonStringify(&zosnsType.Mount, &nsMount.writer);

    // Pid
    var nsPid: std.Io.Writer.Allocating = .init(testing.allocator);
    defer nsPid.deinit();

    try zosnsType.jsonStringify(&zosnsType.Pid, &nsPid.writer);

    // Ipc
    var nsIpc: std.Io.Writer.Allocating = .init(testing.allocator);
    defer nsIpc.deinit();

    try zosnsType.jsonStringify(&zosnsType.Ipc, &nsIpc.writer);

    // Uts
    var nsUts: std.Io.Writer.Allocating = .init(testing.allocator);
    defer nsUts.deinit();

    try zosnsType.jsonStringify(&zosnsType.Uts, &nsUts.writer);

    // test
    try testing.expectEqualStrings(nsMount.written(), "\"mount\"");
    try testing.expectEqualStrings(nsUts.written(), "\"uts\"");
    try testing.expectEqualStrings(nsIpc.written(), "\"ipc\"");
    try testing.expectEqualStrings(nsPid.written(), "\"pid\"");
}
