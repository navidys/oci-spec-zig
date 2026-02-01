const std = @import("std");
const ocispec = @import("ocispec");
const zosns = ocispec.runtime.ZosNamespace;
const zosnsType = ocispec.runtime.ZosNamespaceType;
const testing = std.testing;

test "runtime ZosNamespaceType jsonParse" {
    // Mount
    var nsMount = std.json.Scanner.initCompleteInput(
        testing.allocator,
        "\"mount\"",
    );

    defer nsMount.deinit();

    const nsActMount = try zosns.jsonParse(testing.allocator, &nsMount, .{});

    // Uts
    var nsUts = std.json.Scanner.initCompleteInput(
        testing.allocator,
        "\"utc\"",
    );

    defer nsUts.deinit();

    const nsActUtc = try zosns.jsonParse(testing.allocator, &nsUts, .{});

    // Ipc
    var nsIpc = std.json.Scanner.initCompleteInput(
        testing.allocator,
        "\"ipc\"",
    );

    defer nsIpc.deinit();

    const nsActIpc = try zosns.jsonParse(testing.allocator, &nsIpc, .{});

    // Pid
    var nsPid = std.json.Scanner.initCompleteInput(
        testing.allocator,
        "\"pid\"",
    );

    defer nsPid.deinit();

    const nsActPid = try zosns.jsonParse(testing.allocator, &nsPid, .{});

    // tests
    try testing.expectEqual(zosnsType.Mount, nsActMount);
    try testing.expectEqual(zosnsType.Uts, nsActUtc);
    try testing.expectEqual(zosnsType.Ipc, nsActIpc);
    try testing.expectEqual(zosnsType.Pid, nsActPid);
}

test "runtime ZosNamespaceType jsonStringify" {
    // Mount
    var nsMount = std.ArrayList(u8).init(testing.allocator);
    defer nsMount.deinit();

    try zosns.jsonStringify(&zosnsType.Mount, nsMount.writer());

    // Pid
    var nsPid = std.ArrayList(u8).init(testing.allocator);
    defer nsPid.deinit();

    try zosns.jsonStringify(&zosnsType.Pid, nsPid.writer());

    // Ipc
    var nsIpc = std.ArrayList(u8).init(testing.allocator);
    defer nsIpc.deinit();

    try zosns.jsonStringify(&zosnsType.Ipc, nsIpc.writer());

    // Uts
    var nsUts = std.ArrayList(u8).init(testing.allocator);
    defer nsUts.deinit();

    try zosns.jsonStringify(&zosnsType.Uts, nsUts.writer());

    // test
    try testing.expectEqualStrings(nsMount.items, "\"mount\"");
    try testing.expectEqualStrings(nsUts.items, "\"uts\"");
    try testing.expectEqualStrings(nsIpc.items, "\"ipc\"");
    try testing.expectEqualStrings(nsPid.items, "\"pid\"");
}
