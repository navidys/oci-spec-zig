const std = @import("std");
const utils = @import("../utils.zig");
const define = @import("define.zig");

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
    ociVersion: []const u8,

    /// Specifies the container's root filesystem. On Windows, for Windows
    /// Server Containers, this field is REQUIRED. For Hyper-V
    /// Containers, this field MUST NOT be set.
    ///
    /// On all other platforms, this field is REQUIRED.
    root: define.Root,

    pub fn initFromFile(file_path: []const u8) !Spec {
        const allocator = std.heap.page_allocator;
        const content = try utils.readFileContent(file_path, allocator);

        defer allocator.free(content);

        const parsed = try std.json.parseFromSlice(
            Spec,
            allocator,
            content,
            .{ .allocate = .alloc_always, .ignore_unknown_fields = true },
        );

        return parsed.value;
    }

    /// Attempts to write an image configuration to a string as JSON.
    pub fn toString(self: @This()) ![]const u8 {
        const conf = try utils.toJsonString(self, false);

        return conf;
    }

    /// Attempts to write an image configuration to a string as pretty printed JSON.
    pub fn toStringPretty(self: @This()) ![]const u8 {
        const conf = try utils.toJsonString(self, true);

        return conf;
    }

    /// Attempts to write an image configuration to a file as JSON. If the file already exists, it
    pub fn toFile(self: @This(), file_path: []const u8) !void {
        const content = try self.toString();
        const content_newline = try std.mem.concat(
            std.heap.page_allocator,
            u8,
            &.{ content, "\n" },
        );

        try utils.writeFileContent(file_path, content_newline);
    }

    /// Attempts to write an image configuration to a file as pretty printed JSON. If the file already exists, it
    pub fn toFilePretty(self: @This(), file_path: []const u8) !void {
        const content = try self.toStringPretty();
        const content_newline = try std.mem.concat(
            std.heap.page_allocator,
            u8,
            &.{ content, "\n" },
        );

        try utils.writeFileContent(file_path, content_newline);
    }
};
