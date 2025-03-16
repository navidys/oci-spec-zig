const std = @import("std");
const utils = @import("../utils.zig");
const descriptor = @import("descriptor.zig");
const define = @import("define.zig");

/// Unlike the image index, which contains information about a set of images
/// that can span a variety of architectures and operating systems, an image
/// manifest provides a configuration and set of layers for a single
/// container image for a specific architecture and operating system.
pub const Manifest = struct {
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
    /// artifact. This MUST be set when config.mediaType is set to the empty value. If defined, the
    /// value MUST comply with RFC 6838, including the naming requirements in its section 4.2, and
    /// MAY be registered with IANA. Implementations storing or copying image manifests MUST NOT
    /// error on encountering an artifactType that is unknown to the implementation.
    artifactType: ?define.MediaType = null,

    /// This REQUIRED property references a configuration object for a
    /// container, by digest. Beyond the descriptor requirements,
    /// the value has the following additional restrictions:
    /// The media type descriptor property has additional restrictions for
    /// config. Implementations MUST support at least the following
    /// media types:
    /// - application/vnd.oci.image.config.v1+json
    ///
    /// Manifests concerned with portability SHOULD use one of the above
    /// media types.
    config: descriptor.Descriptor,

    /// Each item in the array MUST be a descriptor. The array MUST have the
    /// base layer at index 0. Subsequent layers MUST then follow in
    /// stack order (i.e. from `layers[0]` to `layers[len(layers)-1]`).
    /// The final filesystem layout MUST match the result of applying
    /// the layers to an empty directory. The ownership, mode, and other
    /// attributes of the initial empty directory are unspecified.
    layers: []descriptor.Descriptor,

    /// This OPTIONAL property specifies a descriptor of another manifest. This value, used by the
    /// referrers API, indicates a relationship to the specified manifest.
    subject: ?descriptor.Descriptor = null,

    /// This OPTIONAL property contains arbitrary metadata for the image
    /// manifest. This OPTIONAL property MUST use the annotation
    /// rules.
    annotations: ?std.json.ArrayHashMap([]const u8) = null,

    /// Attempts to load the image manifest from file.
    pub fn initFromFile(file_path: []const u8) !Manifest {
        const allocator = std.heap.page_allocator;
        const content = try utils.readFileContent(file_path, allocator);

        defer allocator.free(content);

        const parsed = try std.json.parseFromSlice(
            Manifest,
            allocator,
            content,
            .{ .allocate = .alloc_always, .ignore_unknown_fields = true },
        );

        return parsed.value;
    }

    /// Attempts to write the image manifest to a string as JSON.
    pub fn toString(self: @This()) ![]const u8 {
        const conf = try utils.toJsonString(self, false);

        return conf;
    }

    /// Attempts to write the image manifest to a string as pretty printed JSON.
    pub fn toStringPretty(self: @This()) ![]const u8 {
        const conf = try utils.toJsonString(self, true);

        return conf;
    }

    /// Attempts to write the image manifest to a file as JSON. If the file already exists, it
    pub fn toFile(self: @This(), file_path: []const u8) !void {
        const content = try self.toString();
        const content_newline = try std.mem.concat(
            std.heap.page_allocator,
            u8,
            &.{ content, "\n" },
        );

        try utils.writeFileContent(file_path, content_newline);
    }

    /// Attempts to write the image manifest to a file as pretty printed JSON. If the file already exists, it
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
