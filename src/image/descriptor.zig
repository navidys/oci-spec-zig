const std = @import("std");
const define = @import("define.zig");
const digest = @import("digest.zig");

/// A Content Descriptor (or simply Descriptor) describes the disposition of
/// the targeted content. It includes the type of the content, a content
/// identifier (digest), and the byte-size of the raw content.
/// Descriptors SHOULD be embedded in other formats to securely reference
/// external content.
pub const Descriptor = struct {
    /// This REQUIRED property contains the media type of the referenced
    /// content. Values MUST comply with RFC 6838, including the naming
    /// requirements in its section 4.2.
    mediaType: define.MediaType,

    /// This REQUIRED property is the digest of the targeted content,
    /// conforming to the requirements outlined in Digests. Retrieved
    /// content SHOULD be verified against this digest when consumed via
    /// untrusted sources.
    digest: digest.Digest,

    /// This REQUIRED property specifies the size, in bytes, of the raw
    /// content. This property exists so that a client will have an
    /// expected size for the content before processing. If the
    /// length of the retrieved content does not match the specified
    /// length, the content SHOULD NOT be trusted.
    size: u64,

    /// This OPTIONAL property specifies a list of URIs from which this
    /// object MAY be downloaded. Each entry MUST conform to [RFC 3986](https://tools.ietf.org/html/rfc3986).
    /// Entries SHOULD use the http and https schemes, as defined
    /// in [RFC 7230](https://tools.ietf.org/html/rfc7230#section-2.7).
    urls: ?[][]const u8 = null,

    /// This OPTIONAL property contains arbitrary metadata for this
    /// descriptor. This OPTIONAL property MUST use the annotation
    /// rules.
    annotations: ?std.json.ArrayHashMap([]const u8) = null,

    /// This OPTIONAL property describes the minimum runtime requirements of
    /// the image. This property SHOULD be present if its target is
    /// platform-specific.
    platform: ?Platform = null,

    /// This OPTIONAL property contains the type of an artifact when the descriptor points to an
    /// artifact. This is the value of the config descriptor mediaType when the descriptor
    /// references an image manifest. If defined, the value MUST comply with RFC 6838, including
    /// the naming requirements in its section 4.2, and MAY be registered with IANA.
    artifactType: ?define.MediaType = null,

    /// This OPTIONAL property contains an embedded representation of the referenced content.
    /// Values MUST conform to the Base 64 encoding, as defined in RFC 4648. The decoded data MUST
    /// be identical to the referenced content and SHOULD be verified against the digest and size
    /// fields by content consumers. See Embedded Content for when this is appropriate.
    data: ?[]const u8 = null,
};

/// Describes the minimum runtime requirements of the image.
pub const Platform = struct {
    /// This REQUIRED property specifies the CPU architecture.
    /// Image indexes SHOULD use, and implementations SHOULD understand,
    /// values listed in the Go Language document for GOARCH.
    architecture: define.Arch,

    /// This REQUIRED property specifies the operating system.
    /// Image indexes SHOULD use, and implementations SHOULD understand,
    /// values listed in the Go Language document for GOOS.
    os: define.OS,

    /// This OPTIONAL property specifies the version of the operating system
    /// targeted by the referenced blob. Implementations MAY refuse to use
    /// manifests where os.version is not known to work with the host OS
    /// version. Valid values are implementation-defined. e.g.
    /// 10.0.14393.1066 on windows.
    os_version: ?[]const u8 = null,
    /// This OPTIONAL property specifies an array of strings, each
    /// specifying a mandatory OS feature. When os is windows, image
    /// indexes SHOULD use, and implementations SHOULD understand
    /// the following values:
    /// - win32k: image requires win32k.sys on the host (Note: win32k.sys is
    ///   missing on Nano Server)
    ///
    /// When os is not windows, values are implementation-defined and SHOULD
    /// be submitted to this specification for standardization.
    os_features: ?[][]const u8 = null,

    /// This OPTIONAL property specifies the variant of the CPU.
    /// Image indexes SHOULD use, and implementations SHOULD understand,
    /// variant values listed in the [Platform Variants]
    /// (<https://github.com/opencontainers/image-spec/blob/main/image-index.md#platform-variants>)
    /// table.
    variant: ?[]const u8 = null,

    /// This property is RESERVED for future versions of the specification.
    features: ?[][]const u8 = null,
};
