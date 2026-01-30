const std = @import("std");
const Allocator = std.mem.Allocator;

/// Root contains information about the container's root filesystem on the
/// host.
pub const Root = struct {
    /// Path is the absolute path to the container's root filesystem.
    path: []const u8 = "rootfs",

    /// Readonly makes the root filesystem for the container readonly before
    /// the process is executed.
    readonly: ?bool = true,
};

/// Mount specifies a mount for a container.
pub const Mount = struct {
    /// Destination is the absolute path where the mount will be placed in
    /// the container.
    destination: []const u8,

    /// Type specifies the mount kind.
    type: ?[]const u8 = null,

    /// Source specifies the source path of the mount.
    source: ?[]const u8 = null,

    /// Options are fstab style mount options.
    options: ?[][]const u8 = null,
};

pub const ConsoleSize = struct {
    height: u64 = 0,
    width: u64 = 0,

    pub fn init(width: u64, height: u64) ConsoleSize {
        return .{
            .height = height,
            .width = width,
        };
    }
};

pub const User = struct {
    /// uid is the user id.
    uid: u32,

    /// gid is the group id.
    gid: u32,

    /// umask the umask of the user.
    umask: ?u32 = null,

    /// additionalGids are additional group ids set for the container's
    /// process.
    additionalGids: ?[]u32 = null,

    /// username is the user name.
    username: ?[]const u8 = null,
};

/// ExecCPUAffinity specifies CPU affinity used to execute the process.
/// This setting is not applicable to the container's init process.
pub const ExecCPUAffinity = struct {
    /// cpu_affinity_initial is a list of CPUs a runtime parent process to be run on
    /// initially, before the transition to container's cgroup.
    /// This is a a comma-separated list, with dashes to represent ranges.
    /// For example, `0-3,7` represents CPUs 0,1,2,3, and 7.
    initial: ?[]const u8 = null,

    /// cpu_affinity_final is a list of CPUs the process will be run on after the transition
    /// to container's cgroup. The format is the same as for `initial`. If omitted or empty,
    /// runtime SHOULD NOT change process' CPU affinity after the process is moved to
    /// container's cgroup, and the final affinity is determined by the Linux kernel.
    final: ?[]const u8 = null,
};

pub fn getDefaultRootlessMounts(allocator: Allocator) ![]Mount {
    var mounts = std.ArrayList(Mount).init(allocator);

    var pts_opts = std.ArrayList([]const u8).init(allocator);
    try pts_opts.append("nosuid");
    try pts_opts.append("noexec");
    try pts_opts.append("newinstance");
    try pts_opts.append("ptmxmode=0666");
    try pts_opts.append("mode=0620");
    try mounts.append(Mount{
        .destination = "/dev/pts",
        .type = "devpts",
        .source = "devpts",
        .options = try pts_opts.toOwnedSlice(),
    });

    var sys_opts = std.ArrayList([]const u8).init(allocator);
    try sys_opts.append("nosuid");
    try sys_opts.append("noexec");
    try sys_opts.append("nodev");
    try sys_opts.append("ro");
    try sys_opts.append("rbind");
    try mounts.append(Mount{
        .destination = "/sys",
        .type = "sysfs",
        .source = "sysfs",
        .options = try sys_opts.toOwnedSlice(),
    });

    return mounts.toOwnedSlice();
}

pub fn getDefaultMounts(allocator: Allocator) ![]Mount {
    var mounts = std.ArrayList(Mount).init(allocator);
    try mounts.append(Mount{
        .destination = "/proc",
        .type = "proc",
        .source = "proc",
    });

    var dev_opts = std.ArrayList([]const u8).init(allocator);
    try dev_opts.append("nosuid");
    try dev_opts.append("strictatime");
    try dev_opts.append("mode=755");
    try dev_opts.append("size=65536k");
    try mounts.append(Mount{
        .destination = "/dev",
        .type = "tmpfs",
        .source = "tmpfs",
        .options = try dev_opts.toOwnedSlice(),
    });

    var pts_opts = std.ArrayList([]const u8).init(allocator);
    try pts_opts.append("nosuid");
    try pts_opts.append("noexec");
    try pts_opts.append("newinstance");
    try pts_opts.append("ptmxmode=0666");
    try pts_opts.append("mode=0620");
    try pts_opts.append("gid=5");
    try mounts.append(Mount{
        .destination = "/dev/pts",
        .type = "devpts",
        .source = "devpts",
        .options = try pts_opts.toOwnedSlice(),
    });

    var shm_opts = std.ArrayList([]const u8).init(allocator);
    try shm_opts.append("nosuid");
    try shm_opts.append("noexec");
    try shm_opts.append("nodev");
    try shm_opts.append("mode=1777");
    try shm_opts.append("size=65536k");
    try mounts.append(Mount{
        .destination = "/dev/shm",
        .type = "tmpfs",
        .source = "shm",
        .options = try shm_opts.toOwnedSlice(),
    });

    var mqueue_opts = std.ArrayList([]const u8).init(allocator);
    try mqueue_opts.append("nosuid");
    try mqueue_opts.append("noexec");
    try mqueue_opts.append("nodev");
    try mounts.append(Mount{
        .destination = "/dev/mqueue",
        .type = "mqueue",
        .source = "mqueue",
        .options = try mqueue_opts.toOwnedSlice(),
    });

    var sys_opts = std.ArrayList([]const u8).init(allocator);
    try sys_opts.append("nosuid");
    try sys_opts.append("noexec");
    try sys_opts.append("nodev");
    try sys_opts.append("ro");
    try mounts.append(Mount{
        .destination = "/sys",
        .type = "sysfs",
        .source = "sysfs",
        .options = try sys_opts.toOwnedSlice(),
    });

    var cgroup_opts = std.ArrayList([]const u8).init(allocator);
    try cgroup_opts.append("nosuid");
    try cgroup_opts.append("noexec");
    try cgroup_opts.append("nodev");
    try cgroup_opts.append("relatime");
    try cgroup_opts.append("ro");
    try mounts.append(Mount{
        .destination = "/sys/fs/cgroup",
        .type = "cgroup",
        .source = "cgroup",
        .options = try cgroup_opts.toOwnedSlice(),
    });

    return mounts.toOwnedSlice();
}
