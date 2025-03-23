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

pub const Spec = spec.Spec;
pub const Root = define.Root;
pub const Mount = define.Mount;
pub const Version = version.VERSION;
pub const Process = process.Process;
pub const PosixRlimit = posix_rlimit.PosixRlimit;
pub const PosixRlimitType = posix_rlimit.PosixRlimitType;
pub const LinuxIOPriority = io_priority.LinuxIOPriority;
pub const LinuxIOPriorityType = io_priority.LinuxIOPriorityType;
pub const Capability = capability.Capability;
pub const LinuxCapabilities = capability.LinuxCapabilities;
pub const Scheduler = scheduler.Scheduler;
pub const LinuxSchedulerPolicy = scheduler.LinuxSchedulerPolicy;
pub const LinuxSchedulerFlag = scheduler.LinuxSchedulerFlag;
pub const ExecCPUAffinity = define.ExecCPUAffinity;
pub const ConsoleSize = define.ConsoleSize;
pub const User = define.User;
pub const Hooks = hooks.Hooks;
pub const Hook = hooks.Hook;
pub const VM = vm.VM;
pub const VMKernel = vm.VMKernel;
pub const VMImage = vm.VMImage;
pub const VMHypervisor = vm.VMHypervisor;

pub fn defaultMountPoints() ![]define.Mount {
    return try define.getDefaultMounts();
}

pub fn defaultRootlessMountPoints() ![]define.Mount {
    return try define.getDefaultRootlessMounts();
}
