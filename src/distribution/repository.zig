/// RepositoryList returns a catalog of repositories maintained on the registry.
pub const RepositoryList = struct {
    /// The items of the RepositoryList.
    repositories: [][]const u8,
};
