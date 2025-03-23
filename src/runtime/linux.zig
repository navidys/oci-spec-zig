const std = @import("std");

/// Linux contains platform-specific configuration for Linux based
/// containers.
pub const Linux = struct {
    /// uidMappings specifies user mappings for supporting user namespaces.
    uidMappings: ?[]LinuxIdMapping = null,

    /// gidMappings specifies group mappings for supporting user namespaces.
    gidMappings: ?[]LinuxIdMapping = null,

    /// Sysctl are a set of key value pairs that are set for the container
    /// on start.
    sysctl: ?std.json.ArrayHashMap([]const u8) = null,

    /// Resources contain cgroup information for handling resource
    /// constraints for the container.
    resources: ?LinuxResources = null,

    /// CgroupsPath specifies the path to cgroups that are created and/or
    /// joined by the container. The path is expected to be relative
    /// to the cgroups mountpoint. If resources are specified,
    /// the cgroups at CgroupsPath will be updated based on resources.
    cgroupsPath: ?[]const u8 = null,

    /// Namespaces contains the namespaces that are created and/or joined by
    /// the container.
    namespaces: ?[]LinuxNamespace = null,

    /// Devices are a list of device nodes that are created for the
    /// container.
    devices: ?[]LinuxDevice = null,

    /// Seccomp specifies the seccomp security settings for the container.
    seccomp: ?LinuxSeccomp = null,

    /// RootfsPropagation is the rootfs mount propagation mode for the
    /// container.
    rootfsPropagation: ?LinuxRootfsPropagationType = null,

    /// MaskedPaths masks over the provided paths inside the container.
    maskedPaths: ?[][]const u8 = null,

    /// ReadonlyPaths sets the provided paths as RO inside the container.
    readonlyPaths: ?[][]const u8 = null,

    /// MountLabel specifies the selinux context for the mounts in the
    /// container.
    mountLabel: ?[]const u8 = null,

    /// IntelRdt contains Intel Resource Director Technology (RDT)
    /// information for handling resource constraints and monitoring metrics
    /// (e.g., L3 cache, memory bandwidth) for the container.
    intelRdt: ?LinuxIntelRdt = null,

    /// Personality contains configuration for the Linux personality
    /// syscall.
    personality: ?LinuxPersonality = null,

    /// TimeOffsets specifies the offset for supporting time namespaces.
    timeOffsets: ?std.json.ArrayHashMap(LinuxTimeOffsets) = null,
};

pub const LinuxRootfsPropagationType = enum {
    Shared,
    Slave,
    Private,
    Unbindable,

    pub fn jsonStringify(self: *const LinuxRootfsPropagationType, jws: anytype) !void {
        switch (self.*) {
            LinuxRootfsPropagationType.Shared => try jws.print("\"shared\"", .{}),
            LinuxRootfsPropagationType.Slave => try jws.print("\"slave\"", .{}),
            LinuxRootfsPropagationType.Private => try jws.print("\"private\"", .{}),
            LinuxRootfsPropagationType.Unbindable => try jws.print("\"unbindable\"", .{}),
        }
    }

    pub fn jsonParse(allocator: std.mem.Allocator, source: anytype, _: std.json.ParseOptions) !LinuxRootfsPropagationType {
        switch (try source.nextAlloc(allocator, .alloc_if_needed)) {
            .string, .allocated_string => |sched| {
                if (std.mem.eql(u8, sched, "shared") == true) {
                    return LinuxRootfsPropagationType.Shared;
                }

                if (std.mem.eql(u8, sched, "slave") == true) {
                    return LinuxRootfsPropagationType.Slave;
                }

                if (std.mem.eql(u8, sched, "private") == true) {
                    return LinuxRootfsPropagationType.Private;
                }

                if (std.mem.eql(u8, sched, "unbindable") == true) {
                    return LinuxRootfsPropagationType.Unbindable;
                }

                return error.SyntaxError;
            },
            else => return error.UnexpectedToken,
        }

        return error.UnexpectedToken;
    }
};

pub const LinuxTimeOffsets = struct {
    secs: ?i64 = null,
    nanosecs: ?i64 = null,
};

/// Resource constraints for container
pub const LinuxResources = struct {
    /// Devices configures the device allowlist.
    devices: ?[]LinuxDeviceCgroup = null,

    /// Memory restriction configuration.
    memory: ?LinuxMemory = null,

    /// CPU resource restriction configuration.
    cpu: ?LinuxCpu = null,

    /// BlockIO restriction configuration.
    blockIO: ?LinuxBlockIo = null,

    /// Hugetlb limit (in bytes).
    hugepageLimits: ?[]LinuxHugepageLimit = null,

    /// Network restriction configuration.
    network: ?LinuxNetwork = null,

    /// Task resource restrictions
    pids: ?LinuxPids = null,

    /// Rdma resource restriction configuration. Limits are a set of key
    /// value pairs that define RDMA resource limits, where the key
    /// is device name and value is resource limits.
    rdma: ?std.json.ArrayHashMap(LinuxRdma) = null,

    /// Unified resources.
    unified: ?std.json.ArrayHashMap([]const u8) = null,

    /// IntelRdt resources.
    intelRdt: ?std.json.ArrayHashMap(LinuxIntelRdt) = null,
};

/// LinuxNetwork identification and priority configuration.
pub const LinuxNetwork = struct {
    /// Set class identifier for container's network packets
    classID: ?u32 = null,

    /// Set priority of network traffic for container.
    priorities: ?[]LinuxInterfacePriority = null,
};

/// LinuxInterfacePriority for network interfaces.
pub const LinuxInterfacePriority = struct {
    /// Name is the name of the network interface.
    name: []const u8,

    /// Priority for the interface.
    priority: u32,
};

/// LinuxHugepageLimit structure corresponds to limiting kernel hugepages.
/// Default to reservation limits if supported. Otherwise fallback to page fault limits.
pub const LinuxHugepageLimit = struct {
    /// Pagesize is the hugepage size.
    /// Format: "&lt;size&gt;&lt;unit-prefix&gt;B' (e.g. 64KB, 2MB, 1GB, etc.)
    pageSize: []const u8,

    /// Limit is the limit of "hugepagesize" hugetlb reservations (if supported) or usage.
    limit: u64,
};

/// LinuxBlockIO for Linux cgroup 'blkio' resource management.
pub const LinuxBlockIo = struct {
    /// Specifies per cgroup weight.
    weight: ?u16 = null,

    /// Specifies tasks' weight in the given cgroup while competing with the
    /// cgroup's child cgroups, CFQ scheduler only.
    leafWeight: ?u16 = null,

    /// Weight per cgroup per device, can override BlkioWeight.
    weightDevice: ?[]LinuxWeightDevice = null,

    /// IO read rate limit per cgroup per device, bytes per second.
    throttleReadBpsDevice: ?[]LinuxThrottleDevice = null,

    /// IO write rate limit per cgroup per device, bytes per second.
    throttleWriteBpsDevice: ?[]LinuxThrottleDevice = null,

    /// IO read rate limit per cgroup per device, IO per second.
    throttleReadIOPSDevice: ?[]LinuxThrottleDevice = null,

    /// IO write rate limit per cgroup per device, IO per second.
    throttleWriteIOPSDevice: ?[]LinuxThrottleDevice = null,
};

/// LinuxThrottleDevice struct holds a `major:minor rate_per_second` pair.
pub const LinuxThrottleDevice = struct {
    /// Major is the device's major number.
    major: i64,

    /// Minor is the device's minor number.
    minor: i64,

    /// Rate is the IO rate limit per cgroup per device.
    rate: u64,
};

/// LinuxWeightDevice struct holds a `major:minor weight` pair for
/// weightDevice.
pub const LinuxWeightDevice = struct {
    /// Major is the device's major number.
    major: i64,

    /// Minor is the device's minor number.
    minor: i64,

    /// Weight is the bandwidth rate for the device.
    weight: ?u16 = null,

    /// LeafWeight is the bandwidth rate for the device while competing with
    /// the cgroup's child cgroups, CFQ scheduler only.
    leafWeight: ?u16 = null,
};

/// LinuxPids for Linux cgroup 'pids' resource management (Linux 4.3).
pub const LinuxPids = struct {
    /// Maximum number of PIDs. Default is "no limit".
    limit: i64,
};

/// LinuxCPU for Linux cgroup 'cpu' resource management.
pub const LinuxCpu = struct {
    /// CPU shares (relative weight (ratio) vs. other cgroups with cpu
    /// shares).
    shares: ?u64 = null,

    /// CPU hardcap limit (in usecs). Allowed cpu time in a given period.
    quota: ?i64 = null,

    /// Cgroups are configured with minimum weight, 0: default behavior, 1: SCHED_IDLE.
    idle: ?i64 = null,

    /// Maximum amount of accumulated time in microseconds for which tasks
    /// in a cgroup can run additionally for burst during one period
    burst: ?u64 = null,

    /// CPU period to be used for hardcapping (in usecs).
    period: ?u64 = null,

    /// How much time realtime scheduling may use (in usecs).
    realtimeRuntime: ?i64 = null,

    /// CPU period to be used for realtime scheduling (in usecs).
    realtimePeriod: ?u64 = null,

    /// CPUs to use within the cpuset. Default is to use any CPU available.
    cpus: ?[]const u8 = null,

    /// List of memory nodes in the cpuset. Default is to use any available
    /// memory node.
    mems: ?[]const u8 = null,
};

/// LinuxMemory for Linux cgroup 'memory' resource management.
pub const LinuxMemory = struct {
    /// Memory limit (in bytes).
    limit: ?i64 = null,

    /// Memory reservation or soft_limit (in bytes).
    reservation: ?i64 = null,

    /// Total memory limit (memory + swap).
    swap: ?i64 = null,

    /// Kernel memory limit (in bytes).
    kernel: ?i64 = null,

    /// Kernel memory limit for tcp (in bytes).
    kernelTCP: ?i64 = null,

    /// How aggressive the kernel will swap memory pages.
    swappiness: ?i64 = null,

    /// DisableOOMKiller disables the OOM killer for out of memory
    /// conditions.
    disableOOMKiller: ?bool = null,

    /// Enables hierarchical memory accounting
    useHierarchy: ?bool = null,

    /// Enables checking if a new memory limit is lower
    checkBeforeUpdate: ?bool = null,
};

/// Represents a device rule for the devices specified to the device
/// controller
pub const LinuxDeviceCgroup = struct {
    /// Allow or deny
    allow: bool,

    /// Device type, block, char, etc.
    type: ?LinuxDeviceType = null,

    /// Device's major number
    major: ?i64 = null,

    /// Device's minor number
    minor: ?i64 = null,

    /// Cgroup access permissions format, rwm.
    access: ?[]const u8 = null,
};

/// LinuxRdma for Linux cgroup 'rdma' resource management (Linux 4.11).
pub const LinuxRdma = struct {
    /// Maximum number of HCA handles that can be opened. Default is "no
    /// limit".
    hcaHandles: ?u32 = null,

    /// Maximum number of HCA objects that can be created. Default is "no
    /// limit".
    hcaObjects: ?u32 = null,
};

/// LinuxNamespace is the configuration for a Linux namespace.
pub const LinuxNamespace = struct {
    /// Type is the type of namespace.
    type: LinuxNamespaceType,

    /// Path is a path to an existing namespace persisted on disk that can
    /// be joined and is of the same type
    path: ?[]const u8 = null,
};

/// Available Linux namespaces.
pub const LinuxNamespaceType = enum {
    /// Mount Namespace for isolating mount points
    Mount,

    /// Cgroup Namespace for isolating cgroup hierarchies
    Cgroup,

    /// Uts Namespace for isolating hostname and NIS domain name
    Uts,

    /// Ipc Namespace for isolating System V, IPC, POSIX message queues
    Ipc,

    /// User Namespace for isolating user and group  ids
    User,

    /// PID Namespace for isolating process ids
    Pid,

    /// Network Namespace for isolating network devices, ports, stacks etc.
    Network,

    /// Time Namespace for isolating the clocks
    Time,

    pub fn jsonStringify(self: *const LinuxNamespaceType, jws: anytype) !void {
        switch (self.*) {
            LinuxNamespaceType.Mount => try jws.print("\"mount\"", .{}),
            LinuxNamespaceType.Cgroup => try jws.print("\"cgroup\"", .{}),
            LinuxNamespaceType.Uts => try jws.print("\"uts\"", .{}),
            LinuxNamespaceType.Ipc => try jws.print("\"ipc\"", .{}),
            LinuxNamespaceType.User => try jws.print("\"user\"", .{}),
            LinuxNamespaceType.Pid => try jws.print("\"pid\"", .{}),
            LinuxNamespaceType.Network => try jws.print("\"network\"", .{}),
            LinuxNamespaceType.Time => try jws.print("\"time\"", .{}),
        }
    }

    pub fn jsonParse(allocator: std.mem.Allocator, source: anytype, _: std.json.ParseOptions) !LinuxNamespaceType {
        switch (try source.nextAlloc(allocator, .alloc_if_needed)) {
            .string, .allocated_string => |sched| {
                if (std.mem.eql(u8, sched, "mount") == true) {
                    return LinuxNamespaceType.Mount;
                }

                if (std.mem.eql(u8, sched, "cgroup") == true) {
                    return LinuxNamespaceType.Cgroup;
                }

                if (std.mem.eql(u8, sched, "uts") == true) {
                    return LinuxNamespaceType.Uts;
                }

                if (std.mem.eql(u8, sched, "ipc") == true) {
                    return LinuxNamespaceType.Ipc;
                }

                if (std.mem.eql(u8, sched, "user") == true) {
                    return LinuxNamespaceType.User;
                }

                if (std.mem.eql(u8, sched, "pid") == true) {
                    return LinuxNamespaceType.Pid;
                }

                if (std.mem.eql(u8, sched, "network") == true) {
                    return LinuxNamespaceType.Network;
                }

                if (std.mem.eql(u8, sched, "time") == true) {
                    return LinuxNamespaceType.Time;
                }

                return error.SyntaxError;
            },
            else => return error.UnexpectedToken,
        }

        return error.UnexpectedToken;
    }
};

/// LinuxDevice represents the mknod information for a Linux special device
/// file.
pub const LinuxDevice = struct {
    /// Path to the device.
    path: []const u8,

    /// Device type, block, char, etc..
    type: LinuxDeviceType,

    /// Major is the device's major number.
    major: i64,

    /// Minor is the device's minor number.
    minor: i64,

    /// FileMode permission bits for the device.
    fileMode: ?u32 = null,

    /// UID of the device.
    uid: ?u32 = null,

    /// Gid of the device.
    gid: ?u32 = null,
};

/// Device types
pub const LinuxDeviceType = enum {
    /// All
    A,

    /// block (buffered)
    B,

    /// character (unbuffered)
    C,

    /// character (unbufferd)
    U,

    /// FIFO
    P,

    pub fn jsonStringify(self: *const LinuxDeviceType, jws: anytype) !void {
        switch (self.*) {
            LinuxDeviceType.A => try jws.print("\"a\"", .{}),
            LinuxDeviceType.B => try jws.print("\"b\"", .{}),
            LinuxDeviceType.C => try jws.print("\"c\"", .{}),
            LinuxDeviceType.U => try jws.print("\"u\"", .{}),
            LinuxDeviceType.P => try jws.print("\"p\"", .{}),
        }
    }

    pub fn jsonParse(allocator: std.mem.Allocator, source: anytype, _: std.json.ParseOptions) !LinuxDeviceType {
        switch (try source.nextAlloc(allocator, .alloc_if_needed)) {
            .string, .allocated_string => |sched| {
                if (std.mem.eql(u8, sched, "a") == true) {
                    return LinuxDeviceType.A;
                }

                if (std.mem.eql(u8, sched, "b") == true) {
                    return LinuxDeviceType.B;
                }

                if (std.mem.eql(u8, sched, "c") == true) {
                    return LinuxDeviceType.C;
                }

                if (std.mem.eql(u8, sched, "u") == true) {
                    return LinuxDeviceType.U;
                }

                if (std.mem.eql(u8, sched, "p") == true) {
                    return LinuxDeviceType.P;
                }

                return error.SyntaxError;
            },
            else => return error.UnexpectedToken,
        }

        return error.UnexpectedToken;
    }
};

/// LinuxIDMapping specifies UID/GID mappings.
pub const LinuxIdMapping = struct {
    /// hostID is the starting UID/GID on the host to be mapped to
    /// `container_id`.
    hostID: u32,

    /// ContainerID is the starting UID/GID in the container.
    containerID: u32,

    /// Size is the number of IDs to be mapped.
    size: u32,
};

/// LinuxSeccomp represents syscall restrictions.
pub const LinuxSeccomp = struct {
    defaultAction: LinuxSeccompAction,

    /// The default error return code to use when the default action is SCMP_ACT_ERRNO.
    defaultErrnoRet: ?u32 = null,

    /// Available architectures for the restriction.
    architectures: ?[]LinuxSeccompArch = null,

    /// Flags added to the seccomp restriction.
    flags: ?[]LinuxSeccompFilterFlag = null,

    /// The unix domain socket path over which runtime will use for `SCMP_ACT_NOTIFY`.
    listenerPath: ?[]const u8 = null,

    /// An opaque data to pass to the seccomp agent.
    listenerMetadata: ?[]const u8 = null,

    /// The syscalls for the restriction.
    syscalls: ?[]LinuxSyscall = null,
};

/// Available seccomp architectures.
pub const LinuxSeccompArch = enum {
    /// The x86 (32-bit) architecture.
    ScmpArchX86,

    /// The x86-64 (64-bit) architecture.
    ScmpArchX86_64,

    /// The x32 (32-bit x86_64) architecture.
    ///
    /// This is different from the value used by the kernel because we need to
    /// be able to distinguish between x32 and x86_64.
    ScmpArchX32,

    /// The ARM architecture.
    ScmpArchArm,

    /// The AArch64 architecture.
    ScmpArchAarch64,

    /// The MIPS architecture.
    ScmpArchMips,

    /// The MIPS64 architecture.
    ScmpArchMips64,

    /// The MIPS64n32 architecture.
    ScmpArchMips64n32,

    /// The MIPSel architecture.
    ScmpArchMipsel,

    /// The MIPSel64 architecture.
    ScmpArchMipsel64,

    /// The MIPSel64n32 architecture.
    ScmpArchMipsel64n32,

    /// The PowerPC architecture.
    ScmpArchPpc,

    /// The PowerPC64 architecture.
    ScmpArchPpc64,

    /// The PowerPC64le architecture.
    ScmpArchPpc64le,

    /// The S390 architecture.
    ScmpArchS390,

    /// The S390x architecture.
    ScmpArchS390x,

    /// The RISCV64 architecture.
    ScmpArchRiscv64,

    /// The PARISC architecture.
    ScmpArchParisc,

    /// The PARISC64 architecture.
    ScmpArchParisc64,

    /// The LOONGARCH64 architecture.
    ScmpArchLoongarch64,

    /// The M68K architecture.
    ScmpArchM68k,

    /// The sh architecture.
    ScmpArchSh,

    /// The SHEB architecture.
    ScmpArchSheb,

    pub fn jsonStringify(self: *const LinuxSeccompArch, jws: anytype) !void {
        switch (self.*) {
            LinuxSeccompArch.ScmpArchX86 => try jws.print("\"SCMP_ARCH_X86\"", .{}),
            LinuxSeccompArch.ScmpArchX86_64 => try jws.print("\"SCMP_ARCH_X86_64\"", .{}),
            LinuxSeccompArch.ScmpArchX32 => try jws.print("\"SCMP_ARCH_X32\"", .{}),
            LinuxSeccompArch.ScmpArchArm => try jws.print("\"SCMP_ARCH_ARM\"", .{}),
            LinuxSeccompArch.ScmpArchAarch64 => try jws.print("\"SCMP_ARCH_AARCH64\"", .{}),
            LinuxSeccompArch.ScmpArchMips => try jws.print("\"SCMP_ARCH_MIPS\"", .{}),
            LinuxSeccompArch.ScmpArchMips64 => try jws.print("\"SCMP_ARCH_MIPS64\"", .{}),
            LinuxSeccompArch.ScmpArchMips64n32 => try jws.print("\"SCMP_ARCH_MIPS64N32\"", .{}),
            LinuxSeccompArch.ScmpArchMipsel => try jws.print("\"SCMP_ARCH_MIPSEL\"", .{}),
            LinuxSeccompArch.ScmpArchMipsel64 => try jws.print("\"SCMP_ARCH_MIPSEL64\"", .{}),
            LinuxSeccompArch.ScmpArchMipsel64n32 => try jws.print("\"SCMP_ARCH_MIPSEL64N32\"", .{}),
            LinuxSeccompArch.ScmpArchPpc => try jws.print("\"SCMP_ARCH_PPC\"", .{}),
            LinuxSeccompArch.ScmpArchPpc64 => try jws.print("\"SCMP_ARCH_PPC64\"", .{}),
            LinuxSeccompArch.ScmpArchPpc64le => try jws.print("\"SCMP_ARCH_PPC64LE\"", .{}),
            LinuxSeccompArch.ScmpArchS390 => try jws.print("\"SCMP_ARCH_S390\"", .{}),
            LinuxSeccompArch.ScmpArchS390x => try jws.print("\"SCMP_ARCH_S390X\"", .{}),
            LinuxSeccompArch.ScmpArchRiscv64 => try jws.print("\"SCMP_ARCH_RISCV64\"", .{}),
            LinuxSeccompArch.ScmpArchParisc => try jws.print("\"SCMP_ARCH_PARISC\"", .{}),
            LinuxSeccompArch.ScmpArchParisc64 => try jws.print("\"SCMP_ARCH_PARISC64\"", .{}),
            LinuxSeccompArch.ScmpArchLoongarch64 => try jws.print("\"SCMP_ARCH_LOONGARCH64\"", .{}),
            LinuxSeccompArch.ScmpArchM68k => try jws.print("\"SCMP_ARCH_M68K\"", .{}),
            LinuxSeccompArch.ScmpArchSh => try jws.print("\"SCMP_ARCH_SH\"", .{}),
            LinuxSeccompArch.ScmpArchSheb => try jws.print("\"SCMP_ARCH_SHEB\"", .{}),
        }
    }

    pub fn jsonParse(allocator: std.mem.Allocator, source: anytype, _: std.json.ParseOptions) !LinuxSeccompArch {
        switch (try source.nextAlloc(allocator, .alloc_if_needed)) {
            .string, .allocated_string => |sched| {
                if (std.mem.eql(u8, sched, "SCMP_ARCH_X86") == true) {
                    return LinuxSeccompArch.ScmpArchX86;
                }

                if (std.mem.eql(u8, sched, "SCMP_ARCH_X86_64") == true) {
                    return LinuxSeccompArch.ScmpArchX86_64;
                }

                if (std.mem.eql(u8, sched, "SCMP_ARCH_X32") == true) {
                    return LinuxSeccompArch.ScmpArchX32;
                }

                if (std.mem.eql(u8, sched, "SCMP_ARCH_ARM") == true) {
                    return LinuxSeccompArch.ScmpArchArm;
                }

                if (std.mem.eql(u8, sched, "SCMP_ARCH_AARCH64") == true) {
                    return LinuxSeccompArch.ScmpArchAarch64;
                }

                if (std.mem.eql(u8, sched, "SCMP_ARCH_MIPS") == true) {
                    return LinuxSeccompArch.ScmpArchMips;
                }

                if (std.mem.eql(u8, sched, "SCMP_ARCH_MIPS64") == true) {
                    return LinuxSeccompArch.ScmpArchMips64;
                }

                if (std.mem.eql(u8, sched, "SCMP_ARCH_MIPS64N32") == true) {
                    return LinuxSeccompArch.ScmpArchMips64n32;
                }

                if (std.mem.eql(u8, sched, "SCMP_ARCH_MIPSEL") == true) {
                    return LinuxSeccompArch.ScmpArchMipsel;
                }

                if (std.mem.eql(u8, sched, "SCMP_ARCH_MIPSEL64") == true) {
                    return LinuxSeccompArch.ScmpArchMipsel64;
                }

                if (std.mem.eql(u8, sched, "SCMP_ARCH_MIPSEL64N32") == true) {
                    return LinuxSeccompArch.ScmpArchMipsel64n32;
                }

                if (std.mem.eql(u8, sched, "SCMP_ARCH_PPC") == true) {
                    return LinuxSeccompArch.ScmpArchPpc;
                }

                if (std.mem.eql(u8, sched, "SCMP_ARCH_PPC64") == true) {
                    return LinuxSeccompArch.ScmpArchPpc64;
                }

                if (std.mem.eql(u8, sched, "SCMP_ARCH_PPC64LE") == true) {
                    return LinuxSeccompArch.ScmpArchPpc64le;
                }

                if (std.mem.eql(u8, sched, "SCMP_ARCH_S390") == true) {
                    return LinuxSeccompArch.ScmpArchS390;
                }

                if (std.mem.eql(u8, sched, "SCMP_ARCH_S390X") == true) {
                    return LinuxSeccompArch.ScmpArchS390x;
                }

                if (std.mem.eql(u8, sched, "SCMP_ARCH_RISCV64") == true) {
                    return LinuxSeccompArch.ScmpArchRiscv64;
                }

                if (std.mem.eql(u8, sched, "SCMP_ARCH_PARISC") == true) {
                    return LinuxSeccompArch.ScmpArchParisc;
                }

                if (std.mem.eql(u8, sched, "SCMP_ARCH_PARISC64") == true) {
                    return LinuxSeccompArch.ScmpArchParisc64;
                }

                if (std.mem.eql(u8, sched, "SCMP_ARCH_LOONGARCH64") == true) {
                    return LinuxSeccompArch.ScmpArchLoongarch64;
                }

                if (std.mem.eql(u8, sched, "SCMP_ARCH_M68K") == true) {
                    return LinuxSeccompArch.ScmpArchM68k;
                }

                if (std.mem.eql(u8, sched, "SCMP_ARCH_SH") == true) {
                    return LinuxSeccompArch.ScmpArchSh;
                }

                if (std.mem.eql(u8, sched, "SCMP_ARCH_SHEB") == true) {
                    return LinuxSeccompArch.ScmpArchSheb;
                }

                return error.SyntaxError;
            },
            else => return error.UnexpectedToken,
        }

        return error.UnexpectedToken;
    }
};

/// LinuxSyscall is used to match a syscall in seccomp.
pub const LinuxSyscall = struct {
    /// The names of the syscalls.
    names: [][]const u8,

    /// The action to be done for the syscalls.
    action: LinuxSeccompAction,

    /// The error return value.
    errnoRet: ?u32 = null,

    /// The arguments for the syscalls.
    args: ?[]LinuxSeccompArg = null,
};

/// Available seccomp filter flags.
pub const LinuxSeccompFilterFlag = enum {
    /// All filter return actions except SECCOMP_RET_ALLOW should be logged. An administrator may
    /// override this filter flag by preventing specific actions from being logged via the
    /// /proc/sys/kernel/seccomp/actions_logged file. (since Linux 4.14)
    SeccompFilterFlagLog,

    /// When adding a new filter, synchronize all other threads of the calling process to the same
    /// seccomp filter tree. A "filter tree" is the ordered list of filters attached to a thread.
    /// (Attaching identical filters in separate seccomp() calls results in different filters from this
    /// perspective.)
    ///
    /// If any thread cannot synchronize to the same filter tree, the call will not attach the new
    /// seccomp filter, and will fail, returning the first thread ID found that cannot synchronize.
    /// Synchronization will fail if another thread in the same process is in SECCOMP_MODE_STRICT or if
    /// it has attached new seccomp filters to itself, diverging from the calling thread's filter tree.
    SeccompFilterFlagTsync,

    /// Disable Speculative Store Bypass mitigation. (since Linux 4.17)
    SeccompFilterFlagSpecAllow,

    /// Put notifying process in killable state once the notification is received by the userspace listener.
    SeccompFilterFlagWaitKillableRecv,

    pub fn jsonStringify(self: *const LinuxSeccompFilterFlag, jws: anytype) !void {
        switch (self.*) {
            LinuxSeccompFilterFlag.SeccompFilterFlagLog => try jws.print("\"SECCOMP_FILTER_FLAG_LOG\"", .{}),
            LinuxSeccompFilterFlag.SeccompFilterFlagTsync => try jws.print("\"SECCOMP_FILTER_FLAG_TSYNC\"", .{}),
            LinuxSeccompFilterFlag.SeccompFilterFlagSpecAllow => try jws.print("\"SECCOMP_FILTER_FLAG_SPEC_ALLOW\"", .{}),
            LinuxSeccompFilterFlag.SeccompFilterFlagWaitKillableRecv => try jws.print("\"SECCOMP_FILTER_FLAG_WAIT_KILLABLE_RECV\"", .{}),
        }
    }

    pub fn jsonParse(allocator: std.mem.Allocator, source: anytype, _: std.json.ParseOptions) !LinuxSeccompFilterFlag {
        switch (try source.nextAlloc(allocator, .alloc_if_needed)) {
            .string, .allocated_string => |sched| {
                if (std.mem.eql(u8, sched, "SECCOMP_FILTER_FLAG_LOG") == true) {
                    return LinuxSeccompFilterFlag.SeccompFilterFlagLog;
                }

                if (std.mem.eql(u8, sched, "SECCOMP_FILTER_FLAG_TSYNC") == true) {
                    return LinuxSeccompFilterFlag.SeccompFilterFlagTsync;
                }

                if (std.mem.eql(u8, sched, "SECCOMP_FILTER_FLAG_SPEC_ALLOW") == true) {
                    return LinuxSeccompFilterFlag.SeccompFilterFlagSpecAllow;
                }

                if (std.mem.eql(u8, sched, "SECCOMP_FILTER_FLAG_WAIT_KILLABLE_RECV") == true) {
                    return LinuxSeccompFilterFlag.SeccompFilterFlagWaitKillableRecv;
                }

                return error.SyntaxError;
            },
            else => return error.UnexpectedToken,
        }

        return error.UnexpectedToken;
    }
};

/// Available seccomp actions.
pub const LinuxSeccompAction = enum {
    /// Kill the thread, defined for backward compatibility.
    ScmpActKill,

    /// Kill the thread
    ScmpActKillThread,

    /// Kill the process.
    ScmpActKillProcess,

    /// Throw a SIGSYS signal.
    ScmpActTrap,

    /// Return the specified error code.
    ScmpActErrno,

    /// Notifies userspace.
    ScmpActNotify,

    /// Notify a tracing process with the specified value.
    ScmpActTrace,

    /// Allow the syscall to be executed after the action has been logged.
    ScmpActLog,

    /// Allow the syscall to be executed.
    ScmpActAllow,

    pub fn jsonStringify(self: *const LinuxSeccompAction, jws: anytype) !void {
        switch (self.*) {
            LinuxSeccompAction.ScmpActKill => try jws.print("\"SCMP_ACT_KILL\"", .{}),
            LinuxSeccompAction.ScmpActKillThread => try jws.print("\"SCMP_ACT_KILL_THREAD\"", .{}),
            LinuxSeccompAction.ScmpActKillProcess => try jws.print("\"SCMP_ACT_KILL_PROCESS\"", .{}),
            LinuxSeccompAction.ScmpActTrap => try jws.print("\"SCMP_ACT_TRAP\"", .{}),
            LinuxSeccompAction.ScmpActErrno => try jws.print("\"SCMP_ACT_ERRNO\"", .{}),
            LinuxSeccompAction.ScmpActNotify => try jws.print("\"SCMP_ACT_NOTIFY\"", .{}),
            LinuxSeccompAction.ScmpActTrace => try jws.print("\"SCMP_ACT_TRACE\"", .{}),
            LinuxSeccompAction.ScmpActLog => try jws.print("\"SCMP_ACT_LOG\"", .{}),
            LinuxSeccompAction.ScmpActAllow => try jws.print("\"SCMP_ACT_ALLOW\"", .{}),
        }
    }

    pub fn jsonParse(allocator: std.mem.Allocator, source: anytype, _: std.json.ParseOptions) !LinuxSeccompAction {
        switch (try source.nextAlloc(allocator, .alloc_if_needed)) {
            .string, .allocated_string => |sched| {
                if (std.mem.eql(u8, sched, "SCMP_ACT_KILL") == true) {
                    return LinuxSeccompAction.ScmpActKill;
                }

                if (std.mem.eql(u8, sched, "SCMP_ACT_KILL_THREAD") == true) {
                    return LinuxSeccompAction.ScmpActKillThread;
                }

                if (std.mem.eql(u8, sched, "SCMP_ACT_KILL_PROCESS") == true) {
                    return LinuxSeccompAction.ScmpActKillProcess;
                }

                if (std.mem.eql(u8, sched, "SCMP_ACT_TRAP") == true) {
                    return LinuxSeccompAction.ScmpActTrap;
                }

                if (std.mem.eql(u8, sched, "SCMP_ACT_ERRNO") == true) {
                    return LinuxSeccompAction.ScmpActErrno;
                }

                if (std.mem.eql(u8, sched, "SCMP_ACT_NOTIFY") == true) {
                    return LinuxSeccompAction.ScmpActNotify;
                }

                if (std.mem.eql(u8, sched, "SCMP_ACT_TRACE") == true) {
                    return LinuxSeccompAction.ScmpActTrace;
                }

                if (std.mem.eql(u8, sched, "SCMP_ACT_LOG") == true) {
                    return LinuxSeccompAction.ScmpActLog;
                }

                if (std.mem.eql(u8, sched, "SCMP_ACT_ALLOW") == true) {
                    return LinuxSeccompAction.ScmpActAllow;
                }

                return error.SyntaxError;
            },
            else => return error.UnexpectedToken,
        }

        return error.UnexpectedToken;
    }
};

/// LinuxSeccompArg used for matching specific syscall arguments in seccomp.
pub const LinuxSeccompArg = struct {
    /// The index of the argument.
    index: u64,

    /// The value of the argument.
    value: u64,

    /// The second value of the argument.
    valueTwo: ?u64 = null,

    /// The operator for the argument.
    op: LinuxSeccompOperator,
};

/// The seccomp operator to be used for args.
pub const LinuxSeccompOperator = enum {
    /// Refers to the SCMP_CMP_NE operator (not equal).
    ScmpCmpNe,

    /// Refers to the SCMP_CMP_LT operator (less than).
    ScmpCmpLt,

    /// Refers to the SCMP_CMP_LE operator (less equal).
    ScmpCmpLe,

    /// Refers to the SCMP_CMP_EQ operator (equal to).
    ScmpCmpEq,

    /// Refers to the SCMP_CMP_GE operator (greater equal).
    ScmpCmpGe,

    /// Refers to the SCMP_CMP_GT operator (greater than).
    ScmpCmpGt,

    /// Refers to the SCMP_CMP_MASKED_EQ operator (masked equal).
    ScmpCmpMaskedEq,

    pub fn jsonStringify(self: *const LinuxSeccompOperator, jws: anytype) !void {
        switch (self.*) {
            LinuxSeccompOperator.ScmpCmpNe => try jws.print("\"SCMP_CMP_NE\"", .{}),
            LinuxSeccompOperator.ScmpCmpLt => try jws.print("\"SCMP_CMP_LT\"", .{}),
            LinuxSeccompOperator.ScmpCmpLe => try jws.print("\"SCMP_CMP_LE\"", .{}),
            LinuxSeccompOperator.ScmpCmpEq => try jws.print("\"SCMP_CMP_EQ\"", .{}),
            LinuxSeccompOperator.ScmpCmpGe => try jws.print("\"SCMP_CMP_GE\"", .{}),
            LinuxSeccompOperator.ScmpCmpGt => try jws.print("\"SCMP_CMP_GT\"", .{}),
            LinuxSeccompOperator.ScmpCmpMaskedEq => try jws.print("\"SCMP_CMP_MASKED_EQ\"", .{}),
        }
    }

    pub fn jsonParse(allocator: std.mem.Allocator, source: anytype, _: std.json.ParseOptions) !LinuxSeccompOperator {
        switch (try source.nextAlloc(allocator, .alloc_if_needed)) {
            .string, .allocated_string => |sched| {
                if (std.mem.eql(u8, sched, "SCMP_CMP_NE") == true) {
                    return LinuxSeccompOperator.ScmpCmpNe;
                }

                if (std.mem.eql(u8, sched, "SCMP_CMP_LT") == true) {
                    return LinuxSeccompOperator.ScmpCmpLt;
                }

                if (std.mem.eql(u8, sched, "SCMP_CMP_LE") == true) {
                    return LinuxSeccompOperator.ScmpCmpLe;
                }

                if (std.mem.eql(u8, sched, "SCMP_CMP_EQ") == true) {
                    return LinuxSeccompOperator.ScmpCmpEq;
                }

                if (std.mem.eql(u8, sched, "SCMP_CMP_GE") == true) {
                    return LinuxSeccompOperator.ScmpCmpGe;
                }

                if (std.mem.eql(u8, sched, "SCMP_CMP_GT") == true) {
                    return LinuxSeccompOperator.ScmpCmpGt;
                }

                if (std.mem.eql(u8, sched, "SCMP_CMP_MASKED_EQ") == true) {
                    return LinuxSeccompOperator.ScmpCmpMaskedEq;
                }

                return error.SyntaxError;
            },
            else => return error.UnexpectedToken,
        }

        return error.UnexpectedToken;
    }
};

/// LinuxIntelRdt has container runtime resource constraints for Intel RDT CAT and MBA
/// features and flags enabling Intel RDT CMT and MBM features.
/// Intel RDT features are available in Linux 4.14 and newer kernel versions.
pub const LinuxIntelRdt = struct {
    /// The identity for RDT Class of Service.
    closID: ?[]const u8 = null,

    /// The schema for L3 cache id and capacity bitmask (CBM).
    /// Format: "L3:&lt;cache_id0&gt;=&lt;cbm0&gt;;&lt;cache_id1&gt;=&lt;cbm1&gt;;..."
    l3CacheSchema: ?[]const u8 = null,

    /// The schema of memory bandwidth per L3 cache id.
    /// Format: "MB:&lt;cache_id0&gt;=bandwidth0;&lt;cache_id1&gt;=bandwidth1;..."
    /// The unit of memory bandwidth is specified in "percentages" by
    /// default, and in "MBps" if MBA Software Controller is
    /// enabled.
    memBwSchema: ?[]const u8 = null,

    /// EnableCMT is the flag to indicate if the Intel RDT CMT is enabled. CMT (Cache Monitoring Technology) supports monitoring of
    /// the last-level cache (LLC) occupancy for the container.
    enableCMT: ?bool = null,

    /// EnableMBM is the flag to indicate if the Intel RDT MBM is enabled. MBM (Memory Bandwidth Monitoring) supports monitoring of
    /// total and local memory bandwidth for the container.
    enableMBM: ?bool = null,
};

/// LinuxPersonality represents the Linux personality syscall input.
pub const LinuxPersonality = struct {
    /// Domain for the personality.
    domain: LinuxPersonalityDomain,

    /// Additional flags
    flags: ?[][]const u8 = null,
};

/// Define domain and flags for LinuxPersonality.
pub const LinuxPersonalityDomain = enum {
    /// PerLinux is the standard Linux personality.
    PerLinux,

    /// PerLinux32 sets personality to 32 bit.
    PerLinux32,

    pub fn jsonStringify(self: *const LinuxPersonalityDomain, jws: anytype) !void {
        switch (self.*) {
            LinuxPersonalityDomain.PerLinux => try jws.print("\"LINUX\"", .{}),
            LinuxPersonalityDomain.PerLinux32 => try jws.print("\"LINUX32\"", .{}),
        }
    }

    pub fn jsonParse(allocator: std.mem.Allocator, source: anytype, _: std.json.ParseOptions) !LinuxPersonalityDomain {
        switch (try source.nextAlloc(allocator, .alloc_if_needed)) {
            .string, .allocated_string => |sched| {
                if (std.mem.eql(u8, sched, "LINUX") == true) {
                    return LinuxPersonalityDomain.PerLinux;
                }

                if (std.mem.eql(u8, sched, "LINUX32") == true) {
                    return LinuxPersonalityDomain.PerLinux32;
                }

                return error.SyntaxError;
            },
            else => return error.UnexpectedToken,
        }

        return error.UnexpectedToken;
    }
};
