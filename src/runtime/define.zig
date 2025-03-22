/// Root contains information about the container's root filesystem on the
/// host.
pub const Root = struct {
    /// Path is the absolute path to the container's root filesystem.
    path: []const u8 = "rootfs",

    /// Readonly makes the root filesystem for the container readonly before
    /// the process is executed.
    readonly: ?bool = true,
};
