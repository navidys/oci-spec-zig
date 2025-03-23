const std = @import("std");

/// RLimit types and restrictions.
pub const PosixRlimit = struct {
    // Type of Rlimit to set
    type: PosixRlimitType,

    /// Hard limit for specified type
    hard: u64,

    /// Soft limit for specified type
    soft: u64,
};

pub const PosixRlimitType = enum {
    /// Limit in seconds of the amount of CPU time that the process can consume.
    RlimitCpu,

    /// Maximum size in bytes of the files that the process creates.
    RlimitFsize,

    /// Maximum size of the process's data segment (init data, uninit data and
    /// heap) in bytes.
    RlimitData,

    /// Maximum size of the process stack in bytes.
    RlimitStack,

    /// Maximum size of a core dump file in bytes.
    RlimitCore,

    /// Limit on the process's resident set (the number of virtual pages
    /// resident in RAM).
    RlimitRss,

    /// Limit on number of threads for the real uid calling processes.
    RlimitNproc,

    /// One greator than the maximum number of file descriptors that one process
    /// may open.
    RlimitNofile,

    /// Maximum number of bytes of memory that may be locked into RAM.
    RlimitMemlock,

    /// Maximum size of the process's virtual memory(address space) in bytes.
    RlimitAs,

    /// Limit on the number of locks and leases for the process.
    RlimitLocks,

    /// Limit on number of signals that may be queued for the process.
    RlimitSigpending,

    /// Limit on the number of bytes that can be allocated for POSIX message
    /// queue.
    RlimitMsgqueue,

    /// Specifies a ceiling to which the process's nice value can be raised.
    RlimitNice,

    /// Specifies a ceiling on the real-time priority.
    RlimitRtprio,

    /// This is a limit (in microseconds) on the amount of CPU time that a
    /// process scheduled under a real-time scheduling policy may consume
    /// without making a blocking system call.
    RlimitRttime,

    pub fn jsonStringify(self: *const PosixRlimitType, jws: anytype) !void {
        switch (self.*) {
            PosixRlimitType.RlimitCpu => try jws.print("\"RLIMIT_CPU\"", .{}),
            PosixRlimitType.RlimitFsize => try jws.print("\"RLIMIT_FSIZE\"", .{}),
            PosixRlimitType.RlimitData => try jws.print("\"RLIMIT_DATA\"", .{}),
            PosixRlimitType.RlimitStack => try jws.print("\"RLIMIT_STACK\"", .{}),
            PosixRlimitType.RlimitCore => try jws.print("\"RLIMIT_CORE\"", .{}),
            PosixRlimitType.RlimitRss => try jws.print("\"RLIMIT_RSS\"", .{}),
            PosixRlimitType.RlimitNproc => try jws.print("\"RLIMIT_NPROC\"", .{}),
            PosixRlimitType.RlimitNofile => try jws.print("\"RLIMIT_NOFILE\"", .{}),
            PosixRlimitType.RlimitMemlock => try jws.print("\"RLIMIT_MEMLOCK\"", .{}),
            PosixRlimitType.RlimitAs => try jws.print("\"RLIMIT_AS\"", .{}),
            PosixRlimitType.RlimitLocks => try jws.print("\"RLIMIT_LOCKS\"", .{}),
            PosixRlimitType.RlimitSigpending => try jws.print("\"RLIMIT_SIGPENDING\"", .{}),
            PosixRlimitType.RlimitMsgqueue => try jws.print("\"RLIMIT_MSGQUEUE\"", .{}),
            PosixRlimitType.RlimitNice => try jws.print("\"RLIMIT_NICE\"", .{}),
            PosixRlimitType.RlimitRtprio => try jws.print("\"RLIMIT_RTPRIO\"", .{}),
            PosixRlimitType.RlimitRttime => try jws.print("\"RLIMIT_RTTIME\"", .{}),
        }
    }

    pub fn jsonParse(allocator: std.mem.Allocator, source: anytype, _: std.json.ParseOptions) !PosixRlimitType {
        switch (try source.nextAlloc(allocator, .alloc_if_needed)) {
            .string, .allocated_string => |mtype| {
                if (std.mem.eql(u8, mtype, "RLIMIT_CPU") == true) {
                    return PosixRlimitType.RlimitCpu;
                }

                if (std.mem.eql(u8, mtype, "RLIMIT_FSIZE") == true) {
                    return PosixRlimitType.RlimitFsize;
                }

                if (std.mem.eql(u8, mtype, "RLIMIT_DATA") == true) {
                    return PosixRlimitType.RlimitData;
                }

                if (std.mem.eql(u8, mtype, "RLIMIT_STACK") == true) {
                    return PosixRlimitType.RlimitStack;
                }

                if (std.mem.eql(u8, mtype, "RLIMIT_CORE") == true) {
                    return PosixRlimitType.RlimitCore;
                }

                if (std.mem.eql(u8, mtype, "RLIMIT_RSS") == true) {
                    return PosixRlimitType.RlimitRss;
                }

                if (std.mem.eql(u8, mtype, "RLIMIT_NPROC") == true) {
                    return PosixRlimitType.RlimitNproc;
                }

                if (std.mem.eql(u8, mtype, "RLIMIT_NOFILE") == true) {
                    return PosixRlimitType.RlimitNofile;
                }

                if (std.mem.eql(u8, mtype, "RLIMIT_MEMLOCK") == true) {
                    return PosixRlimitType.RlimitMemlock;
                }

                if (std.mem.eql(u8, mtype, "RLIMIT_AS") == true) {
                    return PosixRlimitType.RlimitAs;
                }

                if (std.mem.eql(u8, mtype, "RLIMIT_LOCKS") == true) {
                    return PosixRlimitType.RlimitLocks;
                }

                if (std.mem.eql(u8, mtype, "RLIMIT_SIGPENDING") == true) {
                    return PosixRlimitType.RlimitSigpending;
                }

                if (std.mem.eql(u8, mtype, "RLIMIT_MSGQUEUE") == true) {
                    return PosixRlimitType.RlimitMsgqueue;
                }

                if (std.mem.eql(u8, mtype, "RLIMIT_NICE") == true) {
                    return PosixRlimitType.RlimitNice;
                }

                if (std.mem.eql(u8, mtype, "RLIMIT_RTPRIO") == true) {
                    return PosixRlimitType.RlimitRtprio;
                }

                if (std.mem.eql(u8, mtype, "RLIMIT_RTTIME") == true) {
                    return PosixRlimitType.RlimitRttime;
                }

                return error.SyntaxError;
            },
            else => return error.UnexpectedToken,
        }

        return error.UnexpectedToken;
    }
};
