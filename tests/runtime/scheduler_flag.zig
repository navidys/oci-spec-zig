const std = @import("std");
const ocispec = @import("ocispec");
const schedFlag = ocispec.runtime.LinuxSchedulerFlag;
const testing = std.testing;

test "runtime LinuxSchedulerFlag jsonParse" {
    // SchedResetOnFork
    var resetOnFork = std.json.Scanner.initCompleteInput(
        testing.allocator,
        "\"SCHED_FLAG_RESET_ON_FORK\"",
    );

    defer resetOnFork.deinit();

    const actResultOnFork = try schedFlag.jsonParse(
        testing.allocator,
        &resetOnFork,
        .{},
    );

    // SchedFlagReclaim
    var reclaim = std.json.Scanner.initCompleteInput(
        testing.allocator,
        "\"SCHED_FLAG_RECLAIM\"",
    );

    defer reclaim.deinit();

    const actReclaim = try schedFlag.jsonParse(
        testing.allocator,
        &reclaim,
        .{},
    );

    // SchedFlagDLOverrun
    var dloverrun = std.json.Scanner.initCompleteInput(
        testing.allocator,
        "\"SCHED_FLAG_DL_OVERRUN\"",
    );

    defer dloverrun.deinit();

    const actDloverrun = try schedFlag.jsonParse(
        testing.allocator,
        &dloverrun,
        .{},
    );

    // SchedFlagKeepPolicy
    var keepPolicy = std.json.Scanner.initCompleteInput(
        testing.allocator,
        "\"SCHED_FLAG_KEEP_POLICY\"",
    );

    defer keepPolicy.deinit();

    const actKeepPolicy = try schedFlag.jsonParse(
        testing.allocator,
        &keepPolicy,
        .{},
    );

    // SchedFlagKeepParams
    var keepParam = std.json.Scanner.initCompleteInput(
        testing.allocator,
        "\"SCHED_FLAG_KEEP_PARAMS\"",
    );

    defer keepParam.deinit();

    const actKeepParam = try schedFlag.jsonParse(
        testing.allocator,
        &keepParam,
        .{},
    );

    // SchedFlagUtilClampMin
    var utilClapmMin = std.json.Scanner.initCompleteInput(
        testing.allocator,
        "\"SCHED_FLAG_UTIL_CLAMP_MIN\"",
    );

    defer utilClapmMin.deinit();

    const actUtilClapmMin = try schedFlag.jsonParse(
        testing.allocator,
        &utilClapmMin,
        .{},
    );

    // SchedFlagUtilClampMax
    var utilClapmMax = std.json.Scanner.initCompleteInput(
        testing.allocator,
        "\"SCHED_FLAG_UTIL_CLAMP_MAX\"",
    );

    defer utilClapmMax.deinit();

    const actUtilClapmMax = try schedFlag.jsonParse(
        testing.allocator,
        &utilClapmMax,
        .{},
    );

    // tests
    try testing.expectEqual(schedFlag.SchedResetOnFork, actResultOnFork);
    try testing.expectEqual(schedFlag.SchedFlagReclaim, actReclaim);
    try testing.expectEqual(schedFlag.SchedFlagDLOverrun, actDloverrun);
    try testing.expectEqual(schedFlag.SchedFlagKeepPolicy, actKeepPolicy);
    try testing.expectEqual(schedFlag.SchedFlagKeepParams, actKeepParam);
    try testing.expectEqual(schedFlag.SchedFlagUtilClampMin, actUtilClapmMin);
    try testing.expectEqual(schedFlag.SchedFlagUtilClampMax, actUtilClapmMax);
}

test "runtime LinuxSchedulerFlag jsonStringify" {
    // SchedResetOnFork
    var resetOnFork = std.ArrayList(u8).init(testing.allocator);
    defer resetOnFork.deinit();

    try schedFlag.jsonStringify(&schedFlag.SchedResetOnFork, resetOnFork.writer());

    // SchedFlagReclaim
    var reclaim = std.ArrayList(u8).init(testing.allocator);
    defer reclaim.deinit();

    try schedFlag.jsonStringify(&schedFlag.SchedFlagReclaim, reclaim.writer());

    // SchedFlagDLOverrun
    var overrun = std.ArrayList(u8).init(testing.allocator);
    defer overrun.deinit();

    try schedFlag.jsonStringify(&schedFlag.SchedFlagDLOverrun, overrun.writer());

    // SchedFlagKeepPolicy
    var keepPolicy = std.ArrayList(u8).init(testing.allocator);
    defer keepPolicy.deinit();

    try schedFlag.jsonStringify(&schedFlag.SchedFlagKeepPolicy, keepPolicy.writer());

    // SchedFlagKeepParams
    var keepParam = std.ArrayList(u8).init(testing.allocator);
    defer keepParam.deinit();

    try schedFlag.jsonStringify(&schedFlag.SchedFlagKeepParams, keepParam.writer());

    // SchedFlagUtilClampMin
    var clammin = std.ArrayList(u8).init(testing.allocator);
    defer clammin.deinit();

    try schedFlag.jsonStringify(&schedFlag.SchedFlagUtilClampMin, clammin.writer());

    // SchedFlagUtilClampMax
    var clammax = std.ArrayList(u8).init(testing.allocator);
    defer clammax.deinit();

    try schedFlag.jsonStringify(&schedFlag.SchedFlagUtilClampMax, clammax.writer());

    // test
    try testing.expectEqualStrings(resetOnFork.items, "\"SCHED_FLAG_RESET_ON_FORK\"");
    try testing.expectEqualStrings(reclaim.items, "\"SCHED_FLAG_RECLAIM\"");
    try testing.expectEqualStrings(overrun.items, "\"SCHED_FLAG_DL_OVERRUN\"");
    try testing.expectEqualStrings(keepPolicy.items, "\"SCHED_FLAG_KEEP_POLICY\"");
    try testing.expectEqualStrings(keepParam.items, "\"SCHED_FLAG_KEEP_PARAMS\"");
    try testing.expectEqualStrings(clammin.items, "\"SCHED_FLAG_UTIL_CLAMP_MIN\"");
    try testing.expectEqualStrings(clammax.items, "\"SCHED_FLAG_UTIL_CLAMP_MAX\"");
}
