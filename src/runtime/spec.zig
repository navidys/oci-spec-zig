const std = @import("std");
const utils = @import("../utils.zig");
const define = @import("define.zig");
const version = @import("version.zig");
const process = @import("process.zig");
const hooks = @import("hooks.zig");
const vm = @import("vm.zig");
const linux = @import("linux.zig");
const solaris = @import("solaris.zig");
const zos = @import("zos.zig");
const Allocator = std.mem.Allocator;

/// Base configuration for the container.
pub const Spec = struct {
    ///  MUST be in SemVer v2.0.0 format and specifies the version of the
    /// Open Container Initiative  Runtime Specification with which
    /// the bundle complies. The Open Container Initiative
    ///  Runtime Specification follows semantic versioning and retains
    /// forward and backward  compatibility within major versions.
    /// For example, if a configuration is compliant with
    ///  version 1.1 of this specification, it is compatible with all
    /// runtimes that support any 1.1  or later release of this
    /// specification, but is not compatible with a runtime that supports
    ///  1.0 and not 1.1.
    ociVersion: []const u8 = version.VERSION,

    /// Specifies the container's root filesystem. On Windows, for Windows
    /// Server Containers, this field is REQUIRED. For Hyper-V
    /// Containers, this field MUST NOT be set.
    ///
    /// On all other platforms, this field is REQUIRED.
    root: define.Root,

    /// Specifies additional mounts beyond `root`. The runtime MUST mount
    /// entries in the listed order.
    ///
    /// For Linux, the parameters are as documented in
    /// [`mount(2)`](http://man7.org/linux/man-pages/man2/mount.2.html) system call man page. For
    /// Solaris, the mount entry corresponds to the 'fs' resource in the
    /// [`zonecfg(1M)`](http://docs.oracle.com/cd/E86824_01/html/E54764/zonecfg-1m.html) man page.
    mounts: ?[]define.Mount = null,

    /// Specifies the container process. This property is REQUIRED when
    /// [`start`](https://github.com/opencontainers/runtime-spec/blob/master/runtime.md#start) is
    /// called.
    process: ?process.Process = null,

    /// Specifies the container's hostname as seen by processes running
    /// inside the container. On Linux, for example, this will
    /// change the hostname in the container [UTS namespace](http://man7.org/linux/man-pages/man7/namespaces.7.html). Depending on your
    /// [namespace
    /// configuration](https://github.com/opencontainers/runtime-spec/blob/master/config-linux.md#namespaces),
    /// the container UTS namespace may be the runtime UTS namespace.
    hostname: ?[]const u8 = null,

    /// Specifies the container's domainame as seen by processes running
    /// inside the container. On Linux, for example, this will
    /// change the domainame in the container [UTS namespace](http://man7.org/linux/man-pages/man7/namespaces.7.html). Depending on your
    /// [namespace
    /// configuration](https://github.com/opencontainers/runtime-spec/blob/master/config-linux.md#namespaces),
    /// the container UTS namespace may be the runtime UTS namespace.
    domainname: ?[]const u8 = null,

    /// Hooks allow users to specify programs to run before or after various
    /// lifecycle events. Hooks MUST be called in the listed order.
    /// The state of the container MUST be passed to hooks over
    /// stdin so that they may do work appropriate to the current state of
    /// the container.
    hooks: ?hooks.Hooks = null,

    /// Annotations contains arbitrary metadata for the container. This
    /// information MAY be structured or unstructured. Annotations
    /// MUST be a key-value map. If there are no annotations then
    /// this property MAY either be absent or an empty map.
    ///
    /// Keys MUST be strings. Keys MUST NOT be an empty string. Keys SHOULD
    /// be named using a reverse domain notation - e.g.
    /// com.example.myKey. Keys using the org.opencontainers
    /// namespace are reserved and MUST NOT be used by subsequent
    /// specifications. Runtimes MUST handle unknown annotation keys
    /// like any other unknown property.
    ///
    /// Values MUST be strings. Values MAY be an empty string.
    annotations: ?std.json.ArrayHashMap([]const u8) = null,

    /// linux is platform-specific configuration for Linux based containers.
    linux: ?linux.Linux = null,

    /// solaris is platform-specific configuration for Solaris based
    /// containers.
    solaris: ?solaris.Solaris = null,

    /// zos is platform-specific configuration for Solaris based
    /// containers.
    zos: ?zos.Zos = null,

    /// VM specifies configuration for Virtual Machine based containers.
    vm: ?vm.VM = null,

    pub fn initFromFile(allocator: Allocator, file_path: []const u8) !Spec {
        const content = try utils.readFileContent(allocator, file_path);

        const parsed = try std.json.parseFromSlice(
            Spec,
            allocator,
            content,
            .{ .allocate = .alloc_always, .ignore_unknown_fields = true },
        );

        return parsed.value;
    }

    /// Attempts to write an image configuration to a string as JSON.
    pub fn toString(self: @This(), allocator: Allocator) ![]const u8 {
        const conf = try utils.toJsonString(allocator, self, false);

        return conf;
    }

    /// Attempts to write an image configuration to a string as pretty printed JSON.
    pub fn toStringPretty(self: @This()) ![]const u8 {
        const conf = try utils.toJsonString(self, true);

        return conf;
    }

    /// Attempts to write an image configuration to a file as JSON. If the file already exists, it
    pub fn toFile(self: @This(), allocator: Allocator, file_path: []const u8) !void {
        const content = try self.toString();
        const content_newline = try std.mem.concat(
            allocator,
            u8,
            &.{ content, "\n" },
        );

        try utils.writeFileContent(allocator, file_path, content_newline);
    }

    /// Attempts to write an image configuration to a file as pretty printed JSON. If the file already exists, it
    pub fn toFilePretty(self: @This(), allocator: Allocator, file_path: []const u8) !void {
        const content = try self.toStringPretty();
        const content_newline = try std.mem.concat(
            allocator,
            u8,
            &.{ content, "\n" },
        );

        try utils.writeFileContent(allocator, file_path, content_newline);
    }
};
