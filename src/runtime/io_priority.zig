const std = @import("std");

pub const LinuxIOPriority = struct {
    /// Class represents an I/O scheduling class.
    class: LinuxIOPriorityType,

    priority: i64,
};

/// IOPriorityClass represents an I/O scheduling class.
pub const LinuxIOPriorityType = enum {
    /// This is the realtime io class. This scheduling class is given
    /// higher priority than any other in the system, processes from this class are
    /// given first access to the disk every time. Thus it needs to be used with some
    /// care, one io RT process can starve the entire system. Within the RT class,
    /// there are 8 levels of class data that determine exactly how much time this
    /// process needs the disk for on each service. In the future this might change
    /// to be more directly mappable to performance, by passing in a wanted data
    /// rate instead
    IoprioClassRt,
    /// This is the best-effort scheduling class, which is the default
    /// for any process that hasn't set a specific io priority. The class data
    /// determines how much io bandwidth the process will get, it's directly mappable
    /// to the cpu nice levels just more coarsely implemented. 0 is the highest
    /// BE prio level, 7 is the lowest. The mapping between cpu nice level and io
    /// nice level is determined as: io_nice = (cpu_nice + 20) / 5.
    IoprioClassBe,
    /// This is the idle scheduling class, processes running at this
    /// level only get io time when no one else needs the disk. The idle class has no
    /// class data, since it doesn't really apply here.
    IoprioClassIdle,

    pub fn jsonStringify(self: *const LinuxIOPriorityType, jws: anytype) !void {
        switch (self.*) {
            LinuxIOPriorityType.IoprioClassRt => try jws.print("\"IOPRIO_CLASS_RT\"", .{}),
            LinuxIOPriorityType.IoprioClassBe => try jws.print("\"IOPRIO_CLASS_BE\"", .{}),
            LinuxIOPriorityType.IoprioClassIdle => try jws.print("\"IOPRIO_CLASS_IDLE\"", .{}),
        }
    }

    pub fn jsonParse(allocator: std.mem.Allocator, source: anytype, _: std.json.ParseOptions) !LinuxIOPriorityType {
        switch (try source.nextAlloc(allocator, .alloc_if_needed)) {
            .string, .allocated_string => |prio| {
                if (std.mem.eql(u8, prio, "IOPRIO_CLASS_RT") == true) {
                    return LinuxIOPriorityType.IoprioClassRt;
                }

                if (std.mem.eql(u8, prio, "IOPRIO_CLASS_BE") == true) {
                    return LinuxIOPriorityType.IoprioClassBe;
                }

                if (std.mem.eql(u8, prio, "IOPRIO_CLASS_IDLE") == true) {
                    return LinuxIOPriorityType.IoprioClassIdle;
                }

                return error.SyntaxError;
            },
            else => return error.UnexpectedToken,
        }

        return error.UnexpectedToken;
    }
};
