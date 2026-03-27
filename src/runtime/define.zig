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
    var mounts: std.ArrayListUnmanaged(Mount) = .{};

    var pts_opts: std.ArrayListUnmanaged([]const u8) = .{};
    try pts_opts.append(allocator, "nosuid");
    try pts_opts.append(allocator, "noexec");
    try pts_opts.append(allocator, "newinstance");
    try pts_opts.append(allocator, "ptmxmode=0666");
    try pts_opts.append(allocator, "mode=0620");
    try mounts.append(allocator, Mount{
        .destination = "/dev/pts",
        .type = "devpts",
        .source = "devpts",
        .options = try pts_opts.toOwnedSlice(allocator),
    });

    var sys_opts: std.ArrayListUnmanaged([]const u8) = .{};
    try sys_opts.append(allocator, "nosuid");
    try sys_opts.append(allocator, "noexec");
    try sys_opts.append(allocator, "nodev");
    try sys_opts.append(allocator, "ro");
    try sys_opts.append(allocator, "rbind");
    try mounts.append(allocator, Mount{
        .destination = "/sys",
        .type = "sysfs",
        .source = "sysfs",
        .options = try sys_opts.toOwnedSlice(allocator),
    });

    return mounts.toOwnedSlice(allocator);
}

pub fn getDefaultMounts(allocator: Allocator) ![]Mount {
    var mounts: std.ArrayListUnmanaged(Mount) = .{};
    try mounts.append(allocator, Mount{
        .destination = "/proc",
        .type = "proc",
        .source = "proc",
    });

    var dev_opts: std.ArrayListUnmanaged([]const u8) = .{};
    try dev_opts.append(allocator, "nosuid");
    try dev_opts.append(allocator, "strictatime");
    try dev_opts.append(allocator, "mode=755");
    try dev_opts.append(allocator, "size=65536k");
    try mounts.append(allocator, Mount{
        .destination = "/dev",
        .type = "tmpfs",
        .source = "tmpfs",
        .options = try dev_opts.toOwnedSlice(allocator),
    });

    var pts_opts: std.ArrayListUnmanaged([]const u8) = .{};
    try pts_opts.append(allocator, "nosuid");
    try pts_opts.append(allocator, "noexec");
    try pts_opts.append(allocator, "newinstance");
    try pts_opts.append(allocator, "ptmxmode=0666");
    try pts_opts.append(allocator, "mode=0620");
    try pts_opts.append(allocator, "gid=5");
    try mounts.append(allocator, Mount{
        .destination = "/dev/pts",
        .type = "devpts",
        .source = "devpts",
        .options = try pts_opts.toOwnedSlice(allocator),
    });

    var shm_opts: std.ArrayListUnmanaged([]const u8) = .{};
    try shm_opts.append(allocator, "nosuid");
    try shm_opts.append(allocator, "noexec");
    try shm_opts.append(allocator, "nodev");
    try shm_opts.append(allocator, "mode=1777");
    try shm_opts.append(allocator, "size=65536k");
    try mounts.append(allocator, Mount{
        .destination = "/dev/shm",
        .type = "tmpfs",
        .source = "shm",
        .options = try shm_opts.toOwnedSlice(allocator),
    });

    var mqueue_opts: std.ArrayListUnmanaged([]const u8) = .{};
    try mqueue_opts.append(allocator, "nosuid");
    try mqueue_opts.append(allocator, "noexec");
    try mqueue_opts.append(allocator, "nodev");
    try mounts.append(allocator, Mount{
        .destination = "/dev/mqueue",
        .type = "mqueue",
        .source = "mqueue",
        .options = try mqueue_opts.toOwnedSlice(allocator),
    });

    var sys_opts: std.ArrayListUnmanaged([]const u8) = .{};
    try sys_opts.append(allocator, "nosuid");
    try sys_opts.append(allocator, "noexec");
    try sys_opts.append(allocator, "nodev");
    try sys_opts.append(allocator, "ro");
    try mounts.append(allocator, Mount{
        .destination = "/sys",
        .type = "sysfs",
        .source = "sysfs",
        .options = try sys_opts.toOwnedSlice(allocator),
    });

    var cgroup_opts: std.ArrayListUnmanaged([]const u8) = .{};
    try cgroup_opts.append(allocator, "nosuid");
    try cgroup_opts.append(allocator, "noexec");
    try cgroup_opts.append(allocator, "nodev");
    try cgroup_opts.append(allocator, "relatime");
    try cgroup_opts.append(allocator, "ro");
    try mounts.append(allocator, Mount{
        .destination = "/sys/fs/cgroup",
        .type = "cgroup",
        .source = "cgroup",
        .options = try cgroup_opts.toOwnedSlice(allocator),
    });

    return mounts.toOwnedSlice(allocator);
}
