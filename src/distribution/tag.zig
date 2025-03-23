/// A list of tags for a given repository.
pub const TagList = struct {
    /// The namespace of the repository.
    name: []const u8,

    /// Each tags on the repository.
    tags: [][]const u8,
};
