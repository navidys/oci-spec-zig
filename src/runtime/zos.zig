const std = @import("std");

/// Linux contains platform-specific configuration for Linux based
/// containers.
pub const Zos = struct {
    namespaces: ?[]ZosNamespace = null,
};

/// ZosNamespace is the configuration for a Linux namespace.
pub const ZosNamespace = struct {
    /// Type is the type of namespace.
    type: ZosNamespaceType,

    /// Path is a path to an existing namespace persisted on disk that can
    /// be joined and is of the same type
    path: ?[]const u8 = null,
};

/// Available Linux namespaces.
pub const ZosNamespaceType = enum {
    /// Mount Namespace for isolating mount points
    Mount,

    /// Uts Namespace for isolating hostname and NIS domain name
    Uts,

    /// Ipc Namespace for isolating System V, IPC, POSIX message queues
    Ipc,

    /// PID Namespace for isolating process ids
    Pid,

    pub fn jsonStringify(self: *const ZosNamespaceType, jws: anytype) !void {
        switch (self.*) {
            ZosNamespaceType.Mount => try jws.print("\"mount\"", .{}),
            ZosNamespaceType.Uts => try jws.print("\"uts\"", .{}),
            ZosNamespaceType.Ipc => try jws.print("\"ipc\"", .{}),
            ZosNamespaceType.Pid => try jws.print("\"pid\"", .{}),
        }
    }

    pub fn jsonParse(allocator: std.mem.Allocator, source: anytype, _: std.json.ParseOptions) !ZosNamespaceType {
        switch (try source.nextAlloc(allocator, .alloc_if_needed)) {
            .string, .allocated_string => |sched| {
                if (std.mem.eql(u8, sched, "mount") == true) {
                    return ZosNamespaceType.Mount;
                }

                if (std.mem.eql(u8, sched, "uts") == true) {
                    return ZosNamespaceType.Uts;
                }

                if (std.mem.eql(u8, sched, "ipc") == true) {
                    return ZosNamespaceType.Ipc;
                }

                if (std.mem.eql(u8, sched, "pid") == true) {
                    return ZosNamespaceType.Pid;
                }

                return error.SyntaxError;
            },
            else => return error.UnexpectedToken,
        }

        return error.UnexpectedToken;
    }
};
