const std = @import("std");
const utils = @import("../utils.zig");
const descriptor = @import("descriptor.zig");
const define = @import("define.zig");
const Allocator = std.mem.Allocator;

/// The image index is a higher-level manifest which points to specific
/// image manifests, ideal for one or more platforms. While the use of
/// an image index is OPTIONAL for image providers, image consumers
/// SHOULD be prepared to process them.
pub const Index = struct {
    /// This REQUIRED property specifies the image manifest schema version.
    /// For this version of the specification, this MUST be 2 to ensure
    /// backward compatibility with older versions of Docker. The
    /// value of this field will not change. This field MAY be
    /// removed in a future version of the specification.
    schemaVersion: u32 = 2,

    /// This property is reserved for use, to maintain compatibility. When
    /// used, this field contains the media type of this document,
    /// which differs from the descriptor use of mediaType.
    mediaType: define.MediaType,

    /// This OPTIONAL property contains the type of an artifact when the manifest is used for an
    /// artifact. If defined, the value MUST comply with RFC 6838, including the naming
    /// requirements in its section 4.2, and MAY be registered with IANA.
    artifactType: ?define.MediaType = null,

    /// This REQUIRED property contains a list of manifests for specific
    /// platforms. While this property MUST be present, the size of
    /// the array MAY be zero.
    manifests: []descriptor.Descriptor,

    /// This OPTIONAL property specifies a descriptor of another manifest. This value, used by the
    /// referrers API, indicates a relationship to the specified manifest.
    subject: ?descriptor.Descriptor = null,

    /// This OPTIONAL property contains arbitrary metadata for the image
    /// index. This OPTIONAL property MUST use the annotation rules.
    annotations: ?std.json.ArrayHashMap([]const u8) = null,

    /// Attempts to load the image index from file.
    pub fn initFromFile(allocator: Allocator, file_path: []const u8) !Index {
        const content = try utils.readFileContent(allocator, file_path);

        const parsed = try std.json.parseFromSlice(
            Index,
            allocator,
            content,
            .{ .allocate = .alloc_always, .ignore_unknown_fields = true },
        );

        return parsed.value;
    }

    /// Attempts to write the image index to a string as JSON.
    pub fn toString(self: @This(), allocator: Allocator) ![]const u8 {
        const conf = try utils.toJsonString(allocator, self, false);

        return conf;
    }

    /// Attempts to write the image index to a string as pretty printed JSON.
    pub fn toStringPretty(self: @This(), allocator: Allocator) ![]const u8 {
        const conf = try utils.toJsonString(allocator, self, true);

        return conf;
    }

    /// Attempts to write the image index to a file as JSON. If the file already exists, it
    pub fn toFile(self: @This(), allocator: Allocator, file_path: []const u8) !void {
        const content = try self.toString(allocator);

        try utils.writeFileContent(allocator, file_path, content);
    }

    /// Attempts to write the image index to a file as pretty printed JSON. If the file already exists, it
    pub fn toFilePretty(self: @This(), allocator: Allocator, file_path: []const u8) !void {
        const content = try self.toStringPretty(allocator);

        try utils.writeFileContent(allocator, file_path, content);
    }
};
