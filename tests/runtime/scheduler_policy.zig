const std = @import("std");
const ocispec = @import("ocispec");
const policy = ocispec.runtime.LinuxSchedulerPolicy;
const testing = std.testing;

test "runtime LinuxSchedulerPolicy jsonParse" {
    // SchedOther
    var other = std.json.Scanner.initCompleteInput(
        testing.allocator,
        "\"SCHED_OTHER\"",
    );

    defer other.deinit();

    const actOther = try policy.jsonParse(
        testing.allocator,
        &other,
        .{},
    );

    // SchedFifo
    var fifo = std.json.Scanner.initCompleteInput(
        testing.allocator,
        "\"SCHED_FIFO\"",
    );

    defer fifo.deinit();

    const actFifo = try policy.jsonParse(
        testing.allocator,
        &fifo,
        .{},
    );

    // SchedRr
    var rd = std.json.Scanner.initCompleteInput(
        testing.allocator,
        "\"SCHED_RR\"",
    );

    defer rd.deinit();

    const actRd = try policy.jsonParse(
        testing.allocator,
        &rd,
        .{},
    );

    // SchedBatch
    var batch = std.json.Scanner.initCompleteInput(
        testing.allocator,
        "\"SCHED_BATCH\"",
    );

    defer batch.deinit();

    const actBatch = try policy.jsonParse(
        testing.allocator,
        &batch,
        .{},
    );

    // SchedIso
    var iso = std.json.Scanner.initCompleteInput(
        testing.allocator,
        "\"SCHED_ISO\"",
    );

    defer iso.deinit();

    const actISo = try policy.jsonParse(
        testing.allocator,
        &iso,
        .{},
    );

    // SchedIdle
    var idle = std.json.Scanner.initCompleteInput(
        testing.allocator,
        "\"SCHED_IDLE\"",
    );

    defer idle.deinit();

    const actIdle = try policy.jsonParse(
        testing.allocator,
        &idle,
        .{},
    );

    // SchedDeadline
    var deadline = std.json.Scanner.initCompleteInput(
        testing.allocator,
        "\"SCHED_DEADLINE\"",
    );

    defer deadline.deinit();

    const actDeadline = try policy.jsonParse(
        testing.allocator,
        &deadline,
        .{},
    );

    // tests
    try testing.expectEqual(policy.SchedOther, actOther);
    try testing.expectEqual(policy.SchedFifo, actFifo);
    try testing.expectEqual(policy.SchedRr, actRd);
    try testing.expectEqual(policy.SchedBatch, actBatch);
    try testing.expectEqual(policy.SchedIso, actISo);
    try testing.expectEqual(policy.SchedIdle, actIdle);
    try testing.expectEqual(policy.SchedDeadline, actDeadline);
}

test "runtime LinuxSchedulerPolicy jsonStringify" {
    // SchedOther
    var other = std.ArrayList(u8).init(testing.allocator);
    defer other.deinit();

    try policy.jsonStringify(&policy.SchedOther, other.writer());

    // SchedFifo
    var fifo = std.ArrayList(u8).init(testing.allocator);
    defer fifo.deinit();

    try policy.jsonStringify(&policy.SchedFifo, fifo.writer());

    // SchedRr
    var rr = std.ArrayList(u8).init(testing.allocator);
    defer rr.deinit();

    try policy.jsonStringify(&policy.SchedRr, rr.writer());

    // SchedBatch
    var batch = std.ArrayList(u8).init(testing.allocator);
    defer batch.deinit();

    try policy.jsonStringify(&policy.SchedBatch, batch.writer());

    // SchedIso
    var iso = std.ArrayList(u8).init(testing.allocator);
    defer iso.deinit();

    try policy.jsonStringify(&policy.SchedIso, iso.writer());

    // SchedIdle
    var idle = std.ArrayList(u8).init(testing.allocator);
    defer idle.deinit();

    try policy.jsonStringify(&policy.SchedIdle, idle.writer());

    // SchedDeadline
    var deadline = std.ArrayList(u8).init(testing.allocator);
    defer deadline.deinit();

    try policy.jsonStringify(&policy.SchedDeadline, deadline.writer());

    // test
    try testing.expectEqualStrings(other.items, "\"SCHED_OTHER\"");
    try testing.expectEqualStrings(fifo.items, "\"SCHED_FIFO\"");
    try testing.expectEqualStrings(rr.items, "\"SCHED_RR\"");
    try testing.expectEqualStrings(batch.items, "\"SCHED_BATCH\"");
    try testing.expectEqualStrings(iso.items, "\"SCHED_ISO\"");
    try testing.expectEqualStrings(idle.items, "\"SCHED_IDLE\"");
    try testing.expectEqualStrings(deadline.items, "\"SCHED_DEADLINE\"");
}
