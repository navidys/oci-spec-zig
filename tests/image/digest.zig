const std = @import("std");
const ocispec = @import("ocispec");
const image = ocispec.image;
const testing = std.testing;

test "image digest" {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();

    const image_digest1 = try image.Digest.init(
        image.DigestAlgorithm.Sha256,
        "b5b2b2c507a0944348e0303114d8d93aaaa081732b86451d9bce1f432a537bc7",
    );
    const image_digest1_string: []const u8 = try image_digest1.toString(allocator);
    const image_digest2 = try image.Digest.initFromString(allocator, "sha256:b5b2b2c507a0944348e0303114d8d93aaaa081732b86451d9bce1f432a537bc7");
    const image_digest2_algo = image_digest2.algorithm.toString();

    const image_digest3 = try image.Digest.initFromString(allocator, "sha512:d6f644b19812e97b5d871658d6d3400ecd4787faeb9b8990c1e7608288664be77257104a58d033bcf1a0e0945ff06468ebe53e2dff36e248424c7273117dac09");
    const image_digest3_algo = image_digest3.algorithm.toString();

    try testing.expectEqualStrings(image_digest1_string, "sha256:b5b2b2c507a0944348e0303114d8d93aaaa081732b86451d9bce1f432a537bc7");
    try testing.expectEqualStrings(image_digest2_algo, "sha256");
    try testing.expectEqualStrings(image_digest2.value, "b5b2b2c507a0944348e0303114d8d93aaaa081732b86451d9bce1f432a537bc7");
    try testing.expectEqualStrings(image_digest3_algo, "sha512");
    try testing.expectEqualStrings(image_digest3.value, "d6f644b19812e97b5d871658d6d3400ecd4787faeb9b8990c1e7608288664be77257104a58d033bcf1a0e0945ff06468ebe53e2dff36e248424c7273117dac09");

    const algoError = image.ImageError.InvalidDigestAlogrithm;
    const valueError = image.ImageError.InvalidDigestValue;

    try testing.expectError(
        algoError,
        image.Digest.initFromString(allocator, "sha222:aaa"),
    );

    try testing.expectError(
        valueError,
        image.Digest.initFromString(allocator, "sha512"),
    );

    try testing.expectError(
        valueError,
        image.Digest.initFromString(allocator, "sha512:"),
    );
}
