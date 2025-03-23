const std = @import("std");

pub const Scheduler = struct {
    /// Policy represents the scheduling policy (e.g., SCHED_FIFO, SCHED_RR, SCHED_OTHER).
    policy: LinuxSchedulerPolicy,

    /// nice is the nice value for the process, which affects its priority.
    nice: ?i32 = null,

    /// priority represents the static priority of the process.
    priority: ?i32 = null,

    /// flags is an array of scheduling flags.
    flags: ?[]LinuxSchedulerFlag = null,

    // The following ones are used by the DEADLINE scheduler.
    /// Runtime is the amount of time in nanoseconds during which the process
    /// is allowed to run in a given period.
    runtime: ?u64 = null,

    /// deadline is the absolute deadline for the process to complete its execution.
    deadline: ?u64 = null,

    /// period is the length of the period in nanoseconds used for determining the process runtime.
    period: ?u64 = null,
};

///  LinuxSchedulerPolicy represents different scheduling policies used with the Linux Scheduler
pub const LinuxSchedulerPolicy = enum {
    /// SchedOther is the default scheduling policy
    SchedOther,
    /// SchedFIFO is the First-In-First-Out scheduling policy
    SchedFifo,
    /// SchedRR is the Round-Robin scheduling policy
    SchedRr,
    /// SchedBatch is the Batch scheduling policy
    SchedBatch,
    /// SchedISO is the Isolation scheduling policy
    SchedIso,
    /// SchedIdle is the Idle scheduling policy
    SchedIdle,
    /// SchedDeadline is the Deadline scheduling policy
    SchedDeadline,

    pub fn jsonStringify(self: *const LinuxSchedulerPolicy, jws: anytype) !void {
        switch (self.*) {
            LinuxSchedulerPolicy.SchedOther => try jws.print("\"SCHED_OTHER\"", .{}),
            LinuxSchedulerPolicy.SchedFifo => try jws.print("\"SCHED_FIFO\"", .{}),
            LinuxSchedulerPolicy.SchedRr => try jws.print("\"SCHED_RR\"", .{}),
            LinuxSchedulerPolicy.SchedBatch => try jws.print("\"SCHED_BATCH\"", .{}),
            LinuxSchedulerPolicy.SchedIso => try jws.print("\"SCHED_ISO\"", .{}),
            LinuxSchedulerPolicy.SchedIdle => try jws.print("\"SCHED_IDLE\"", .{}),
            LinuxSchedulerPolicy.SchedDeadline => try jws.print("\"SCHED_DEADLINE\"", .{}),
        }
    }

    pub fn jsonParse(allocator: std.mem.Allocator, source: anytype, _: std.json.ParseOptions) !LinuxSchedulerPolicy {
        switch (try source.nextAlloc(allocator, .alloc_if_needed)) {
            .string, .allocated_string => |sched| {
                if (std.mem.eql(u8, sched, "SCHED_OTHER") == true) {
                    return LinuxSchedulerPolicy.SchedOther;
                }

                if (std.mem.eql(u8, sched, "SCHED_FIFO") == true) {
                    return LinuxSchedulerPolicy.SchedFifo;
                }

                if (std.mem.eql(u8, sched, "SCHED_RR") == true) {
                    return LinuxSchedulerPolicy.SchedRr;
                }

                if (std.mem.eql(u8, sched, "SCHED_BATCH") == true) {
                    return LinuxSchedulerPolicy.SchedBatch;
                }

                if (std.mem.eql(u8, sched, "SCHED_ISO") == true) {
                    return LinuxSchedulerPolicy.SchedIso;
                }

                if (std.mem.eql(u8, sched, "SCHED_IDLE") == true) {
                    return LinuxSchedulerPolicy.SchedIdle;
                }

                if (std.mem.eql(u8, sched, "SCHED_DEADLINE") == true) {
                    return LinuxSchedulerPolicy.SchedDeadline;
                }

                return error.SyntaxError;
            },
            else => return error.UnexpectedToken,
        }

        return error.UnexpectedToken;
    }
};

///  LinuxSchedulerFlag represents the flags used by the Linux Scheduler.
pub const LinuxSchedulerFlag = enum {
    /// SchedFlagResetOnFork represents the reset on fork scheduling flag
    SchedResetOnFork,
    /// SchedFlagReclaim represents the reclaim scheduling flag
    SchedFlagReclaim,
    /// SchedFlagDLOverrun represents the deadline overrun scheduling flag
    SchedFlagDLOverrun,
    /// SchedFlagKeepPolicy represents the keep policy scheduling flag
    SchedFlagKeepPolicy,
    /// SchedFlagKeepParams represents the keep parameters scheduling flag
    SchedFlagKeepParams,
    /// SchedFlagUtilClampMin represents the utilization clamp minimum scheduling flag
    SchedFlagUtilClampMin,
    /// SchedFlagUtilClampMin represents the utilization clamp maximum scheduling flag
    SchedFlagUtilClampMax,

    pub fn jsonStringify(self: *const LinuxSchedulerFlag, jws: anytype) !void {
        switch (self.*) {
            LinuxSchedulerFlag.SchedResetOnFork => try jws.print("\"SCHED_FLAG_RESET_ON_FORK\"", .{}),
            LinuxSchedulerFlag.SchedFlagReclaim => try jws.print("\"SCHED_FLAG_RECLAIM\"", .{}),
            LinuxSchedulerFlag.SchedFlagDLOverrun => try jws.print("\"SCHED_FLAG_DL_OVERRUN\"", .{}),
            LinuxSchedulerFlag.SchedFlagKeepPolicy => try jws.print("\"SCHED_FLAG_KEEP_POLICY\"", .{}),
            LinuxSchedulerFlag.SchedFlagKeepParams => try jws.print("\"SCHED_FLAG_KEEP_PARAMS\"", .{}),
            LinuxSchedulerFlag.SchedFlagUtilClampMin => try jws.print("\"SCHED_FLAG_UTIL_CLAMP_MIN\"", .{}),
            LinuxSchedulerFlag.SchedFlagUtilClampMax => try jws.print("\"SCHED_FLAG_UTIL_CLAMP_MAX\"", .{}),
        }
    }

    pub fn jsonParse(allocator: std.mem.Allocator, source: anytype, _: std.json.ParseOptions) !LinuxSchedulerFlag {
        switch (try source.nextAlloc(allocator, .alloc_if_needed)) {
            .string, .allocated_string => |flag| {
                if (std.mem.eql(u8, flag, "SCHED_FLAG_RESET_ON_FORK") == true) {
                    return LinuxSchedulerFlag.SchedResetOnFork;
                }

                if (std.mem.eql(u8, flag, "SCHED_FLAG_RECLAIM") == true) {
                    return LinuxSchedulerFlag.SchedFlagReclaim;
                }

                if (std.mem.eql(u8, flag, "SCHED_FLAG_DL_OVERRUN") == true) {
                    return LinuxSchedulerFlag.SchedFlagDLOverrun;
                }

                if (std.mem.eql(u8, flag, "SCHED_FLAG_KEEP_POLICY") == true) {
                    return LinuxSchedulerFlag.SchedFlagKeepPolicy;
                }

                if (std.mem.eql(u8, flag, "SCHED_FLAG_KEEP_PARAMS") == true) {
                    return LinuxSchedulerFlag.SchedFlagKeepParams;
                }

                if (std.mem.eql(u8, flag, "SCHED_FLAG_UTIL_CLAMP_MIN") == true) {
                    return LinuxSchedulerFlag.SchedFlagUtilClampMin;
                }

                if (std.mem.eql(u8, flag, "SCHED_FLAG_UTIL_CLAMP_MAX") == true) {
                    return LinuxSchedulerFlag.SchedFlagUtilClampMax;
                }

                return error.SyntaxError;
            },
            else => return error.UnexpectedToken,
        }

        return error.UnexpectedToken;
    }
};
