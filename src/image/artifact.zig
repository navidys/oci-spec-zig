const std = @import("std");
const utils = @import("../utils.zig");
const descriptor = @import("descriptor.zig");
const define = @import("define.zig");

/// The OCI Artifact manifest describes content addressable artifacts
/// in order to store them along side container images in a registry.
pub const ArtifactManifest = struct {
    /// This property MUST be used and contain the media type
    /// `application/vnd.oci.artifact.manifest.v1+json`.
    mediaType: define.MediaType,

    /// This property SHOULD be used and contain
    /// the mediaType of the referenced artifact.
    /// If defined, the value MUST comply with RFC 6838,
    /// including the naming requirements in its section 4.2,
    /// and MAY be registered with IANA.
    artifactType: define.MediaType,

    /// This OPTIONAL property is an array of objects and each item
    /// in the array MUST be a descriptor. Each descriptor represents
    /// an artifact of any IANA mediaType. The list MAY be ordered
    /// for certain artifact types like scan results.
    blobs: ?[]descriptor.Descriptor = null,

    /// This OPTIONAL property specifies a descriptor of another manifest.
    /// This value, used by the referrers API, indicates a relationship
    /// to the specified manifest.
    subject: ?descriptor.Descriptor = null,

    /// This OPTIONAL property contains additional metadata for the artifact
    /// manifest. This OPTIONAL property MUST use the annotation rules.
    /// See Pre-Defined Annotation Keys. Annotations MAY be used to filter
    /// the response from the referrers API.
    annotations: ?std.json.ArrayHashMap([]const u8) = null,

    /// Attempts to load the artifact manifest from file.
    pub fn initFromFile(file_path: []const u8) !ArtifactManifest {
        const allocator = std.heap.page_allocator;
        const content = try utils.readFileContent(file_path, allocator);

        defer allocator.free(content);

        const parsed = try std.json.parseFromSlice(
            ArtifactManifest,
            allocator,
            content,
            .{ .allocate = .alloc_always, .ignore_unknown_fields = true },
        );

        return parsed.value;
    }

    /// Attempts to write the artifact manifest to a string as JSON.
    pub fn toString(self: @This()) ![]const u8 {
        const conf = try utils.toJsonString(self, false);

        return conf;
    }

    /// Attempts to write the artifact manifest to a string as pretty printed JSON.
    pub fn toStringPretty(self: @This()) ![]const u8 {
        const conf = try utils.toJsonString(self, true);

        return conf;
    }

    /// Attempts to write the artifact manifest to a file as JSON. If the file already exists, it
    pub fn toFile(self: @This(), file_path: []const u8) !void {
        const content = try self.toString();

        try utils.writeFileContent(file_path, content);
    }

    /// Attempts to write the artifact manifest to a file as pretty printed JSON. If the file already exists, it
    pub fn toFilePretty(self: @This(), file_path: []const u8) !void {
        const content = try self.toStringPretty();

        try utils.writeFileContent(file_path, content);
    }
};
