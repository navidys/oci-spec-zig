/// Solaris contains platform-specific configuration for Solaris application
/// containers.
pub const Solaris = struct {
    /// SMF FMRI which should go "online" before we start the container
    /// process.
    milestone: ?[]const u8 = null,

    /// Maximum set of privileges any process in this container can obtain.
    limitpriv: ?[]const u8 = null,

    /// The maximum amount of shared memory allowed for this container.
    maxShmMemory: ?[]const u8 = null,

    /// Specification for automatic creation of network resources for this
    /// container.
    anet: ?[]SolarisAnet = null,

    /// Set limit on the amount of CPU time that can be used by container.
    cappedCPU: ?SolarisCappedCPU = null,

    /// The physical and swap caps on the memory that can be used by this
    /// container.
    cappedMemory: ?SolarisCappedMemory = null,
};

/// SolarisAnet provides the specification for automatic creation of network
/// resources for this container.
pub const SolarisAnet = struct {
    /// Specify a name for the automatically created VNIC datalink.
    linkname: ?[]const u8 = null,

    /// Specify the link over which the VNIC will be created.
    lowerLink: ?[]const u8 = null,

    /// The set of IP addresses that the container can use.
    allowedAddress: ?[]const u8 = null,

    /// Specifies whether allowedAddress limitation is to be applied to the
    /// VNIC.
    configureAllowedAddress: ?[]const u8 = null,

    /// The value of the optional default router.
    defrouter: ?[]const u8 = null,

    /// Enable one or more types of link protection.
    linkProtection: ?[]const u8 = null,

    /// Set the VNIC's macAddress.
    macAddress: ?[]const u8 = null,
};

/// SolarisCappedCPU allows users to set limit on the amount of CPU time
/// that can be used by container.
pub const SolarisCappedCPU = struct {
    ncpus: ?[]const u8 = null,
};

/// SolarisCappedMemory allows users to set the physical and swap caps on
/// the memory that can be used by this container.
pub const SolarisCappedMemory = struct {
    /// The physical caps on the memory.
    physical: ?[]const u8 = null,

    /// The swap caps on the memory.
    swap: ?[]const u8 = null,
};
