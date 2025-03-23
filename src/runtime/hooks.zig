/// Hooks specifies a command that is run in the container at a particular
/// event in the lifecycle (setup and teardown) of a container.
pub const Hooks = struct {
    /// The `prestart` hooks MUST be called after the `start` operation is
    /// called but before the user-specified program command is
    /// executed.
    ///
    /// On Linux, for example, they are called after the container
    /// namespaces are created, so they provide an opportunity to
    /// customize the container (e.g. the network namespace could be
    /// specified in this hook).
    ///
    /// The `prestart` hooks' path MUST resolve in the runtime namespace.
    /// The `prestart` hooks MUST be executed in the runtime namespace.
    prestart: ?[]Hook = null,

    /// CreateRuntime is a list of hooks to be run after the container has
    /// been created but before `pivot_root` or any equivalent
    /// operation has been called. It is called in the Runtime
    /// Namespace.
    create_runtime: ?[]Hook = null,

    /// CreateContainer is a list of hooks to be run after the container has
    /// been created but before `pivot_root` or any equivalent
    /// operation has been called. It is called in the
    /// Container Namespace.
    create_container: ?[]Hook = null,

    /// StartContainer is a list of hooks to be run after the start
    /// operation is called but before the container process is
    /// started. It is called in the Container Namespace.
    start_container: ?[]Hook = null,

    /// Poststart is a list of hooks to be run after the container process
    /// is started. It is called in the Runtime Namespace.
    poststart: ?[]Hook = null,

    /// Poststop is a list of hooks to be run after the container process
    /// exits. It is called in the Runtime Namespace.
    poststop: ?[]Hook = null,
};

/// Hook specifies a command that is run at a particular event in the
/// lifecycle of a container.
pub const Hook = struct {
    /// Path to the binary to be executed. Following similar semantics to
    /// [IEEE Std 1003.1-2008 `execv`'s path](https://pubs.opengroup.org/onlinepubs/9699919799/functions/exec.html). This
    /// specification extends the IEEE standard in that path MUST be
    /// absolute.
    path: []const u8,

    /// Arguments used for the binary, including the binary name itself.
    /// Following the same semantics as [IEEE Std 1003.1-2008
    /// `execv`'s argv](https://pubs.opengroup.org/onlinepubs/9699919799/functions/exec.html).
    args: ?[][]const u8 = null,

    /// Additional `key=value` environment variables. Following the same
    /// semantics as [IEEE Std 1003.1-2008's `environ`](https://pubs.opengroup.org/onlinepubs/9699919799/basedefs/V1_chap08.html#tag_08_01).
    env: ?[][]const u8 = null,

    /// Timeout is the number of seconds before aborting the hook. If set,
    /// timeout MUST be greater than zero.
    timeout: ?i64 = null,
};
