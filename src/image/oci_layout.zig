const std = @import("std");
const utils = @import("../utils.zig");
const version = @import("version.zig");
const Allocator = std.mem.Allocator;

/// The oci layout JSON object serves as a marker for the base of an Open Container Image Layout
/// and to provide the version of the image-layout in use. The imageLayoutVersion value will align
/// with the OCI Image Specification version at the time changes to the layout are made, and will
/// pin a given version until changes to the image layout are required.
pub const OciLayout = struct {
    imageLayoutVersion: []const u8 = version.VERSION,

    pub fn initFromFile(allocator: Allocator, file_path: []const u8) !OciLayout {
        const content = try utils.readFileContent(allocator, file_path);

        const parsed = try std.json.parseFromSlice(
            OciLayout,
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
    pub fn toStringPretty(self: @This(), allocator: Allocator) ![]const u8 {
        const conf = try utils.toJsonString(allocator, self, true);

        return conf;
    }

    /// Attempts to write an image configuration to a file as JSON. If the file already exists, it
    pub fn toFile(self: @This(), allocator: Allocator, file_path: []const u8) !void {
        const content = try self.toString(allocator);

        try utils.writeFileContent(allocator, file_path, content);
    }

    /// Attempts to write an image configuration to a file as pretty printed JSON. If the file already exists, it
    pub fn toFilePretty(self: @This(), allocator: Allocator, file_path: []const u8) !void {
        const content = try self.toStringPretty(allocator);

        try utils.writeFileContent(allocator, file_path, content);
    }
};
