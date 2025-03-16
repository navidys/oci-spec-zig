/// ANNOTATION_CREATED is the annotation key for the date and time on which the
/// image was built (date-time string as defined by RFC 3339).
pub const ANNOTATION_CREATED: []const u8 = "org.opencontainers.image.created";

/// ANNOTATION_AUTHORS is the annotation key for the contact details of the
/// people or organization responsible for the image (freeform string).
pub const ANNOTATION_AUTHORS: []const u8 = "org.opencontainers.image.authors";

/// ANNOTATION_URL is the annotation key for the URL to find more information on
/// the image.
pub const ANNOTATION_URL: []const u8 = "org.opencontainers.image.url";

/// ANNOTATION_DOCUMENTATION is the annotation key for the URL to get
/// documentation on the image.
pub const ANNOTATION_DOCUMENTATION: []const u8 = "org.opencontainers.image.documentation";

/// ANNOTATION_SOURCE is the annotation key for the URL to get source code for
/// building the image.
pub const ANNOTATION_SOURCE: []const u8 = "org.opencontainers.image.source";

/// ANNOTATION_VERSION is the annotation key for the version of the packaged
/// software. The version MAY match a label or tag in the source code
/// repository. The version MAY be Semantic versioning-compatible.
pub const ANNOTATION_VERSION: []const u8 = "org.opencontainers.image.version";

/// ANNOTATION_REVISION is the annotation key for the source control revision
/// identifier for the packaged software.
pub const ANNOTATION_REVISION: []const u8 = "org.opencontainers.image.revision";

/// ANNOTATION_VENDOR is the annotation key for the name of the distributing
/// entity, organization or individual.
pub const ANNOTATION_VENDOR: []const u8 = "org.opencontainers.image.vendor";

/// ANNOTATION_LICENSES is the annotation key for the license(s) under which
/// contained software is distributed as an SPDX License Expression.
pub const ANNOTATION_LICENSES: []const u8 = "org.opencontainers.image.licenses";

/// ANNOTATION_REF_NAME is the annotation key for the name of the reference for a
/// target. SHOULD only be considered valid when on descriptors on `index.json`
/// within image layout.
pub const ANNOTATION_REF_NAME: []const u8 = "org.opencontainers.image.ref.name";

/// ANNOTATION_TITLE is the annotation key for the human-readable title of the
/// image.
pub const ANNOTATION_TITLE: []const u8 = "org.opencontainers.image.title";

/// ANNOTATION_DESCRIPTION is the annotation key for the human-readable
/// description of the software packaged in the image.
pub const ANNOTATION_DESCRIPTION: []const u8 = "org.opencontainers.image.description";

/// ANNOTATION_BASE_IMAGE_DIGEST is the annotation key for the digest of the
/// image's base image.
pub const ANNOTATION_BASE_IMAGE_DIGEST: []const u8 = "org.opencontainers.image.base.digest";

/// ANNOTATION_BASE_IMAGE_NAME is the annotation key for the image reference of the
/// image's base image.
pub const ANNOTATION_BASE_IMAGE_NAME: []const u8 = "org.opencontainers.image.base.name";
