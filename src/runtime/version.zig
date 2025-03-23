/// API incompatible changes.
pub const VERSION_MAJOR: []const u8 = "1";

/// Changing functionality in a backwards-compatible manner
pub const VERSION_MINOR: []const u8 = "2";

/// Backwards-compatible bug fixes.
pub const VERSION_PATCH: []const u8 = "1";

pub const VERSION = VERSION_MAJOR ++ "." ++ VERSION_MINOR ++ "." ++ VERSION_PATCH;
