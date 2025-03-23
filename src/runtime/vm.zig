/// VM contains information for virtual-machine-based containers.
pub const VM = struct {
    /// Hypervisor specifies hypervisor-related configuration for
    /// virtual-machine-based containers.
    hypervisor: ?VMHypervisor = null,

    /// Kernel specifies kernel-related configuration for
    /// virtual-machine-based containers.
    kernel: VMKernel,

    /// Image specifies guest image related configuration for
    /// virtual-machine-based containers.
    image: ?VMImage = null,
};

/// VMHypervisor contains information about the hypervisor to use for a
/// virtual machine.
pub const VMHypervisor = struct {
    /// Path is the host path to the hypervisor used to manage the virtual
    /// machine.
    path: []const u8,

    /// Parameters specifies parameters to pass to the hypervisor.
    parameters: ?[][]const u8 = null,
};

/// VMKernel contains information about the kernel to use for a virtual
/// machine.
pub const VMKernel = struct {
    /// Path is the host path to the kernel used to boot the virtual
    /// machine.
    path: []const u8,

    /// Parameters specifies parameters to pass to the kernel.
    parameters: ?[][]const u8 = null,

    /// InitRD is the host path to an initial ramdisk to be used by the
    /// kernel.
    initrd: ?[]const u8 = null,
};

/// VMImage contains information about the virtual machine root image.
pub const VMImage = struct {
    /// Path is the host path to the root image that the VM kernel would
    /// boot into.
    path: []const u8,

    /// Format is the root image format type (e.g. "qcow2", "raw", "vhd",
    /// etc).
    format: []const u8,
};
