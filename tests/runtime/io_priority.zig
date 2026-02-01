const std = @import("std");
const ocispec = @import("ocispec");
const iopriority = ocispec.runtime.LinuxIOPriorityType;
const testing = std.testing;

test "runtime LinuxIOPriorityType jsonParse" {
    // IoprioClassRt
    var rt = std.json.Scanner.initCompleteInput(
        testing.allocator,
        "\"IOPRIO_CLASS_RT\"",
    );

    defer rt.deinit();

    const actRt = try iopriority.jsonParse(
        testing.allocator,
        &rt,
        .{},
    );

    // IoprioClassBe
    var be = std.json.Scanner.initCompleteInput(
        testing.allocator,
        "\"IOPRIO_CLASS_BE\"",
    );

    defer be.deinit();

    const actBe = try iopriority.jsonParse(
        testing.allocator,
        &be,
        .{},
    );

    // IoprioClassIdle
    var idle = std.json.Scanner.initCompleteInput(
        testing.allocator,
        "\"IOPRIO_CLASS_IDLE\"",
    );

    defer idle.deinit();

    const actIdle = try iopriority.jsonParse(
        testing.allocator,
        &idle,
        .{},
    );

    // tests
    try testing.expectEqual(iopriority.IoprioClassRt, actRt);
    try testing.expectEqual(iopriority.IoprioClassBe, actBe);
    try testing.expectEqual(iopriority.IoprioClassIdle, actIdle);
}

test "runtime LinuxSchedulerPolicy jsonStringify" {
    // IoprioClassRt
    var rt = std.ArrayList(u8).init(testing.allocator);
    defer rt.deinit();

    try iopriority.jsonStringify(&iopriority.IoprioClassRt, rt.writer());

    // IoprioClassBe
    var be = std.ArrayList(u8).init(testing.allocator);
    defer be.deinit();

    try iopriority.jsonStringify(&iopriority.IoprioClassBe, be.writer());

    // IoprioClassIdle
    var idle = std.ArrayList(u8).init(testing.allocator);
    defer idle.deinit();

    try iopriority.jsonStringify(&iopriority.IoprioClassIdle, idle.writer());

    // test
    try testing.expectEqualStrings(rt.items, "\"IOPRIO_CLASS_RT\"");
    try testing.expectEqualStrings(rt.items, "\"IOPRIO_CLASS_BE\"");
    try testing.expectEqualStrings(rt.items, "\"IOPRIO_CLASS_IDLE\"");
}
