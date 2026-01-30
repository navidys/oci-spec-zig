const std = @import("std");
const errors = @import("errors.zig");
const Allocator = std.mem.Allocator;

/// A digest algorithm; at the current time only SHA-256
/// is widely used and supported in the ecosystem. Other
/// SHA variants are included as they are noted in the
/// standards.
pub const DigestAlgorithm = enum {
    /// The SHA-256 algorithm.
    Sha256,
    /// The SHA-284 algorithm.
    Sha384,
    /// The SHA-512 algorithm.
    Sha512,

    pub fn toString(self: @This()) []const u8 {
        switch (self) {
            DigestAlgorithm.Sha256 => return "sha256",
            DigestAlgorithm.Sha384 => return "sha384",
            DigestAlgorithm.Sha512 => return "sha512",
        }
    }
};

pub const Digest = struct {
    algorithm: DigestAlgorithm,
    value: []const u8,

    pub fn init(algo: DigestAlgorithm, value: []const u8) !Digest {
        if (value.len == 0) {
            return error.InvalidDigestValue;
        }

        return .{
            .algorithm = algo,
            .value = value,
        };
    }

    pub fn initFromString(allocator: Allocator, digest: []const u8) !Digest {
        var digestR = Digest{
            .algorithm = DigestAlgorithm.Sha256,
            .value = "a",
        };

        var it = std.mem.splitScalar(u8, digest, ':');
        const algo = it.next();
        const hash = it.next();

        if (hash) |hashValue| {
            if (hashValue.len == 0) {
                return error.InvalidDigestValue;
            }
            digestR.value = try allocator.dupe(u8, hashValue);
        } else {
            return errors.ImageError.InvalidDigestValue;
        }

        if (algo) |algoValue| {
            if (std.mem.eql(u8, algoValue, "sha256") == true) {
                digestR.algorithm = DigestAlgorithm.Sha256;
            } else if (std.mem.eql(u8, algoValue, "sha384") == true) {
                digestR.algorithm = DigestAlgorithm.Sha384;
            } else if (std.mem.eql(u8, algoValue, "sha512") == true) {
                digestR.algorithm = DigestAlgorithm.Sha512;
            } else {
                return errors.ImageError.InvalidDigestAlogrithm;
            }
        }

        return digestR;
    }

    pub fn toString(self: @This(), allocator: Allocator) ![]const u8 {
        const algo = self.algorithm.toString();
        const value = self.value;
        const digest_string = try std.mem.concat(
            allocator,
            u8,
            &.{ algo, ":", value },
        );

        return digest_string;
    }

    pub fn jsonStringify(self: *const Digest, jws: anytype) !void {
        var algo: []const u8 = "";

        switch (self.algorithm) {
            DigestAlgorithm.Sha256 => algo = "sha256",
            DigestAlgorithm.Sha384 => algo = "sha384",
            DigestAlgorithm.Sha512 => algo = "sha512",
        }

        try jws.print("\"{s}:{s}\"", .{ algo, self.value });
    }

    pub fn jsonParse(allocator: Allocator, source: anytype, _: std.json.ParseOptions) !Digest {
        var digestR = Digest{
            .algorithm = DigestAlgorithm.Sha256,
            .value = "a",
        };

        switch (try source.nextAlloc(allocator, .alloc_if_needed)) {
            .string, .allocated_string => |digestValue| {
                var it = std.mem.splitScalar(u8, digestValue, ':');
                const algo = it.next();
                const hash = it.next();

                if (hash) |hashValue| {
                    digestR.value = try allocator.dupe(u8, hashValue);
                } else {
                    return error.SyntaxError;
                }

                if (algo) |algoValue| {
                    if (std.mem.eql(u8, algoValue, "sha256") == true) {
                        digestR.algorithm = DigestAlgorithm.Sha256;
                    } else if (std.mem.eql(u8, algoValue, "sha384") == true) {
                        digestR.algorithm = DigestAlgorithm.Sha384;
                    } else if (std.mem.eql(u8, algoValue, "sha512") == true) {
                        digestR.algorithm = DigestAlgorithm.Sha512;
                    } else {
                        return error.SyntaxError;
                    }
                }
            },
            else => return error.UnexpectedToken,
        }

        return digestR;
    }
};
