const spec = @import("spec.zig");
const define = @import("define.zig");
const version = @import("version.zig");
const process = @import("process.zig");
const capability = @import("capability.zig");
const posix_rlimit = @import("posix_rlimit.zig");
const io_priority = @import("io_priority.zig");
const scheduler = @import("scheduler.zig");
const hooks = @import("hooks.zig");
const vm = @import("vm.zig");
const linux = @import("linux.zig");
const solaris = @import("solaris.zig");
const zod = @import("zos.zig");

pub const Spec = spec.Spec;
pub const Process = process.Process;
pub const Capability = capability.Capability;
pub const Scheduler = scheduler.Scheduler;
pub const PosixRlimit = posix_rlimit.PosixRlimit;
pub const PosixRlimitType = posix_rlimit.PosixRlimitType;
pub const Hooks = hooks.Hooks;
pub const Hook = hooks.Hook;
pub const VM = vm.VM;
pub const VMKernel = vm.VMKernel;
pub const VMImage = vm.VMImage;
pub const VMHypervisor = vm.VMHypervisor;
pub const SolarisAnet = solaris.SolarisAnet;
pub const SolarisCappedCPU = solaris.SolarisCappedCPU;
pub const SolarisCappedMemory = solaris.SolarisCappedMemory;
pub const Linux = linux.Linux;
pub const LinuxResources = linux.LinuxResources;
pub const LinuxNetwork = linux.LinuxNetwork;
pub const LinuxInterfacePriority = linux.LinuxInterfacePriority;
pub const LinuxHugepageLimit = linux.LinuxHugepageLimit;
pub const LinuxBlockIo = linux.LinuxBlockIo;
pub const LinuxThrottleDevice = linux.LinuxThrottleDevice;
pub const LinuxWeightDevice = linux.LinuxWeightDevice;
pub const LinuxPids = linux.LinuxPids;
pub const LinuxCpu = linux.LinuxCpu;
pub const LinuxMemory = linux.LinuxMemory;
pub const LinuxDeviceCgroup = linux.LinuxDeviceCgroup;
pub const LinuxRdma = linux.LinuxRdma;
pub const LinuxNamespace = linux.LinuxNamespace;
pub const LinuxNamespaceType = linux.LinuxNamespaceType;
pub const LinuxDevice = linux.LinuxDevice;
pub const LinuxDeviceType = linux.LinuxDeviceType;
pub const LinuxIdMapping = linux.LinuxIdMapping;
pub const LinuxSeccomp = linux.LinuxSeccomp;
pub const LinuxSeccompArch = linux.LinuxSeccompArch;
pub const LinuxSyscall = linux.LinuxSyscall;
pub const LinuxSeccompFilterFlag = linux.LinuxSeccompFilterFlag;
pub const LinuxSeccompAction = linux.LinuxSeccompAction;
pub const LinuxSeccompArg = linux.LinuxSeccompArg;
pub const LinuxSeccompOperator = linux.LinuxSeccompOperator;
pub const LinuxIntelRdt = linux.LinuxIntelRdt;
pub const LinuxPersonality = linux.LinuxPersonality;
pub const LinuxPersonalityDomain = linux.LinuxPersonalityDomain;
pub const LinuxTimeOffsets = linux.LinuxTimeOffsets;
pub const LinuxRootfsPropagationType = linux.LinuxRootfsPropagationType;
pub const LinuxIOPriority = io_priority.LinuxIOPriority;
pub const LinuxIOPriorityType = io_priority.LinuxIOPriorityType;
pub const LinuxCapabilities = capability.LinuxCapabilities;
pub const LinuxSchedulerPolicy = scheduler.LinuxSchedulerPolicy;
pub const LinuxSchedulerFlag = scheduler.LinuxSchedulerFlag;
pub const Root = define.Root;
pub const Mount = define.Mount;
pub const ExecCPUAffinity = define.ExecCPUAffinity;
pub const ConsoleSize = define.ConsoleSize;
pub const User = define.User;
pub const Version = version.VERSION;

pub fn defaultMountPoints() ![]define.Mount {
    return try define.getDefaultMounts();
}

pub fn defaultRootlessMountPoints() ![]define.Mount {
    return try define.getDefaultRootlessMounts();
}
