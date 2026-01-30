const std = @import("std");
const utils = @import("../utils.zig");
const define = @import("define.zig");
const Allocator = std.mem.Allocator;

/// The image configuration is associated with an image and describes some
/// basic information about the image such as date created, author, as
/// well as execution/runtime configuration like its entrypoint, default
/// arguments, networking, and volumes.
pub const ImageConfiguration = struct {
    /// An combined date and time at which the image was created,
    /// formatted as defined by [RFC 3339, section 5.6.](https://tools.ietf.org/html/rfc3339#section-5.6)
    created: []const u8,

    /// Gives the name and/or email address of the person or entity
    /// which created and is responsible for maintaining the image.
    author: ?[]const u8 = null,

    /// The CPU architecture which the binaries in this
    /// image are built to run on. Configurations SHOULD use, and
    /// implementations SHOULD understand, values listed in the Go
    /// Language document for [GOARCH](https://golang.org/doc/install/source#environment).
    architecture: define.Arch,

    /// The name of the operating system which the image is built to run on.
    /// Configurations SHOULD use, and implementations SHOULD understand,
    /// values listed in the Go Language document for [GOOS](https://golang.org/doc/install/source#environment).
    os: define.OS,

    /// This OPTIONAL property specifies the version of the operating
    /// system targeted by the referenced blob. Implementations MAY refuse
    /// to use manifests where os.version is not known to work with
    /// the host OS version. Valid values are
    /// implementation-defined. e.g. 10.0.14393.1066 on windows.
    os_version: ?[]const u8 = null,

    /// This OPTIONAL property specifies an array of strings,
    /// each specifying a mandatory OS feature. When os is windows, image
    /// indexes SHOULD use, and implementations SHOULD understand
    /// the following values:
    /// - win32k: image requires win32k.sys on the host (Note: win32k.sys is
    ///   missing on Nano Server)
    os_features: ?[][]const u8 = null,

    /// The variant of the specified CPU architecture. Configurations SHOULD
    /// use, and implementations SHOULD understand, variant values
    /// listed in the [Platform Variants](https://github.com/opencontainers/image-spec/blob/main/image-index.md#platform-variants) table.
    variant: ?[]const u8 = null,

    /// The execution parameters which SHOULD be used as a base when
    /// running a container using the image. This field can be None, in
    /// which case any execution parameters should be specified at
    /// creation of the container.
    config: ?Config = null,

    /// The rootfs key references the layer content addresses used by the
    /// image. This makes the image config hash depend on the
    /// filesystem hash.
    rootfs: RootFS,

    /// Describes the history of each layer. The array is ordered from first
    /// to last.
    history: ?[]const History = null,

    /// Attempts to load the image configuration from file.
    pub fn initFromFile(allocator: Allocator, file_path: []const u8) !ImageConfiguration {
        const content = try utils.readFileContent(allocator, file_path);

        const parsed = try std.json.parseFromSlice(
            ImageConfiguration,
            allocator,
            content,
            .{ .allocate = .alloc_always, .ignore_unknown_fields = true },
        );

        return parsed.value;
    }

    /// Attempts to write the image configuration to a string as JSON.
    pub fn toString(self: @This(), allocator: Allocator) ![]const u8 {
        const conf = try utils.toJsonString(allocator, self, false);

        return conf;
    }

    /// Attempts to write the image configuration to a string as pretty printed JSON.
    pub fn toStringPretty(self: @This(), allocator: Allocator) ![]const u8 {
        const conf = try utils.toJsonString(allocator, self, true);

        return conf;
    }

    /// Attempts to write the image configuration to a file as JSON. If the file already exists, it
    pub fn toFile(self: @This(), allocator: Allocator, file_path: []const u8) !void {
        const content = try self.toString(allocator);

        try utils.writeFileContent(allocator, file_path, content);
    }

    /// Attempts to write the image configuration to a file as pretty printed JSON. If the file already exists, it
    pub fn toFilePretty(self: @This(), allocator: Allocator, file_path: []const u8) !void {
        const content = try self.toStringPretty(allocator);

        try utils.writeFileContent(allocator, file_path, content);
    }
};

/// The execution parameters which SHOULD be used as a base when
/// running a container using the image.
pub const Config = struct {
    /// The username or UID which is a platform-specific
    /// structure that allows specific control over which
    /// user the process run as. This acts as a default
    /// value to use when the value is not specified when
    /// creating a container. For Linux based systems, all
    /// of the following are valid: user, uid, user:group,
    /// uid:gid, uid:group, user:gid. If group/gid is not
    /// specified, the default group and supplementary
    /// groups of the given user/uid in /etc/passwd from
    /// the container are applied.
    User: ?[]const u8 = null,

    /// A set of ports to expose from a container running this
    /// image. Its keys can be in the format of: port/tcp, port/udp,
    /// port with the default protocol being tcp if not specified.
    /// These values act as defaults and are merged with any
    /// specified when creating a container.
    ExposedPorts: ?std.json.ArrayHashMap(std.json.ArrayHashMap([]const u8)) = null,

    /// Entries are in the format of VARNAME=VARVALUE. These
    /// values act as defaults and are merged with any
    /// specified when creating a container.
    Env: ?[][]const u8 = null,

    /// A list of arguments to use as the command to execute
    /// when the container starts. These values act as defaults
    /// and may be replaced by an entrypoint specified when
    /// creating a container.
    Entrypoint: ?[][]const u8 = null,

    /// Default arguments to the entrypoint of the container.
    /// These values act as defaults and may be replaced by any
    /// specified when creating a container. If an Entrypoint
    /// value is not specified, then the first entry of the Cmd
    /// array SHOULD be interpreted as the executable to run.
    Cmd: ?[][]const u8 = null,

    /// A set of directories describing where the process is
    /// likely to write data specific to a container instance.
    Volumes: ?std.json.ArrayHashMap(std.json.ArrayHashMap([]const u8)) = null,

    /// Sets the current working directory of the entrypoint process
    /// in the container. This value acts as a default and may be
    /// replaced by a working directory specified when creating
    /// a container.
    WorkingDir: ?[]const u8 = null,

    /// The field contains arbitrary metadata for the container.
    /// This property MUST use the annotation rules.
    Labels: ?std.json.ArrayHashMap([]const u8) = null,

    /// The field contains the system call signal that will be
    /// sent to the container to exit. The signal can be a signal
    /// name in the format SIGNAME, for instance SIGKILL or SIGRTMIN+3.
    StopSignal: ?[]const u8 = null,
};

/// RootFs references the layer content addresses used by the image.
pub const RootFS = struct {
    /// MUST be set to layers.
    type: []const u8,
    /// An array of layer content hashes (DiffIDs), in order
    /// from first to last.
    diff_ids: [][]const u8,
};

/// Describes the history of a layer.
pub const History = struct {
    /// A combined date and time at which the layer was created,
    /// formatted as defined by [RFC 3339, section 5.6.](https://tools.ietf.org/html/rfc3339#section-5.6).
    created: ?[]const u8 = null,

    /// The author of the build point.
    author: ?[]const u8 = null,

    /// The command which created the layer.
    created_by: ?[]const u8 = null,

    /// A custom message set when creating the layer.
    comment: ?[]const u8 = null,

    /// This field is used to mark if the history item created
    /// a filesystem diff. It is set to true if this history item
    /// doesn't correspond to an actual layer in the rootfs section
    empty_layer: ?bool = null,
};
