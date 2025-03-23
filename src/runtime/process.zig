const std = @import("std");
const cap = @import("capability.zig");
const posix_rlimit = @import("posix_rlimit.zig");
const io_priority = @import("io_priority.zig");
const define = @import("define.zig");
const scheduler = @import("scheduler.zig");

/// Process contains information to start a specific application inside the
/// container.
pub const Process = struct {
    /// terminal creates an interactive terminal for the container.
    terminal: ?bool = null,

    /// consoleSize specifies the size of the console.
    consoleSize: ?define.ConsoleSize = null,

    /// user specifies user information for the process.
    user: define.User,

    /// args specifies the binary and arguments for the application to
    /// execute.
    args: ?[][]const u8 = null,

    /// commandLine specifies the full command line for the application to
    /// execute on Windows.
    commandLine: ?[]const u8 = null,

    /// env populates the process environment for the process.
    env: ?[][]const u8 = null,

    /// cwd is the current working directory for the process and must be
    /// relative to the container's root.
    cwd: []const u8,

    /// capabilities are Linux capabilities that are kept for the process.
    capabilities: ?cap.LinuxCapabilities = null,

    /// rlimits specifies rlimit options to apply to the process.
    rlimits: ?[]posix_rlimit.PosixRlimit = null,

    /// noNewPrivileges controls whether additional privileges could be
    /// gained by processes in the container.
    noNewPrivileges: ?bool = null,

    /// apparmorProfile specifies the apparmor profile for the container.
    apparmorProfile: ?[]const u8 = null,

    /// Specify an oomScoreAdj for the container.
    oomScoreAdj: ?i32 = null,

    /// selinuxLabel specifies the selinux context that the container
    /// process is run as.
    selinuxLabel: ?[]const u8 = null,

    /// ioPriority contains the I/O priority settings for the cgroup.
    ioPriority: ?io_priority.LinuxIOPriority = null,

    /// scheduler specifies the scheduling attributes for a process
    scheduler: ?scheduler.Scheduler = null,

    /// execCPUAffinity specifies the cpu affinity for a process
    execCPUAffinity: ?define.ExecCPUAffinity = null,
};
