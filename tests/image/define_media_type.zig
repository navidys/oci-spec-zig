const std = @import("std");
const ocispec = @import("ocispec");
const imgtype = ocispec.image.MediaType;
const testing = std.testing;

test "image define OS jsonParse" {
    // Descriptor
    var typeDesc = std.json.Scanner.initCompleteInput(
        testing.allocator,
        "\"application/vnd.oci.descriptor\"",
    );

    defer typeDesc.deinit();

    const actualDesc = try imgtype.jsonParse(
        testing.allocator,
        &typeDesc,
        .{},
    );

    // LayoutHeader
    var typeLayoutHeader = std.json.Scanner.initCompleteInput(
        testing.allocator,
        "\"application/vnd.oci.layout.header.v1+json\"",
    );

    defer typeLayoutHeader.deinit();

    const actualLayoutHeader = try imgtype.jsonParse(
        testing.allocator,
        &typeLayoutHeader,
        .{},
    );

    // ImageManifest
    var typeImageManifest = std.json.Scanner.initCompleteInput(
        testing.allocator,
        "\"application/vnd.oci.image.manifest.v1+json\"",
    );

    defer typeImageManifest.deinit();

    const actualImageManifest = try imgtype.jsonParse(
        testing.allocator,
        &typeImageManifest,
        .{},
    );

    // ImageIndex
    var typeImageIndex = std.json.Scanner.initCompleteInput(
        testing.allocator,
        "\"application/vnd.oci.image.index.v1+json\"",
    );

    defer typeImageIndex.deinit();

    const actualImageIndex = try imgtype.jsonParse(
        testing.allocator,
        &typeImageIndex,
        .{},
    );

    // ImageLayer
    var typeImageLayer = std.json.Scanner.initCompleteInput(
        testing.allocator,
        "\"application/vnd.oci.image.layer.v1.tar\"",
    );

    defer typeImageLayer.deinit();

    const actualImageLayer = try imgtype.jsonParse(
        testing.allocator,
        &typeImageLayer,
        .{},
    );

    // ImageLayerGzip
    var typeImageLayerGzip = std.json.Scanner.initCompleteInput(
        testing.allocator,
        "\"application/vnd.oci.image.layer.v1.tar+gzip\"",
    );

    defer typeImageLayerGzip.deinit();

    const actualImageLayerGzip = try imgtype.jsonParse(
        testing.allocator,
        &typeImageLayerGzip,
        .{},
    );

    // ImageLayerZstd
    var typeImageLayerZstd = std.json.Scanner.initCompleteInput(
        testing.allocator,
        "\"application/vnd.oci.image.layer.v1.tar+zstd\"",
    );

    defer typeImageLayerZstd.deinit();

    const actualImageLayerZstd = try imgtype.jsonParse(
        testing.allocator,
        &typeImageLayerZstd,
        .{},
    );

    // ImageLayerNonDistributable
    var typeImageLayerNontDist = std.json.Scanner.initCompleteInput(
        testing.allocator,
        "\"application/vnd.oci.image.layer.nondistributable.v1.tar\"",
    );

    defer typeImageLayerNontDist.deinit();

    const actualImageLayerNonDist = try imgtype.jsonParse(
        testing.allocator,
        &typeImageLayerNontDist,
        .{},
    );

    // ImageLayerNonDistributableGzip
    var typeImageLayerNontDistGzip = std.json.Scanner.initCompleteInput(
        testing.allocator,
        "\"application/vnd.oci.image.layer.nondistributable.v1.tar+gzip\"",
    );

    defer typeImageLayerNontDistGzip.deinit();

    const actualImageLayerNonDistGzip = try imgtype.jsonParse(
        testing.allocator,
        &typeImageLayerNontDistGzip,
        .{},
    );

    // ImageLayerNonDistributableZstd
    var typeImageLayerNontDistZstd = std.json.Scanner.initCompleteInput(
        testing.allocator,
        "\"application/vnd.oci.image.layer.nondistributable.v1.tar+zstd\"",
    );

    defer typeImageLayerNontDistZstd.deinit();

    const actualImageLayerNonDistZstd = try imgtype.jsonParse(
        testing.allocator,
        &typeImageLayerNontDistZstd,
        .{},
    );

    // ImageConfig
    var typeImageConfig = std.json.Scanner.initCompleteInput(
        testing.allocator,
        "\"application/vnd.oci.image.config.v1+json\"",
    );

    defer typeImageConfig.deinit();

    const actualImageConfig = try imgtype.jsonParse(
        testing.allocator,
        &typeImageConfig,
        .{},
    );

    // ArtifactManifest
    var typeArtifactManifest = std.json.Scanner.initCompleteInput(
        testing.allocator,
        "\"application/vnd.oci.artifact.manifest.v1+json\"",
    );

    defer typeArtifactManifest.deinit();

    const actualArtifactManifest = try imgtype.jsonParse(
        testing.allocator,
        &typeArtifactManifest,
        .{},
    );

    // EmptyJSON
    var typeEmptyJSON = std.json.Scanner.initCompleteInput(
        testing.allocator,
        "\"application/vnd.oci.empty.v1+json\"",
    );

    defer typeEmptyJSON.deinit();

    const actualEmptyJSON = try imgtype.jsonParse(
        testing.allocator,
        &typeEmptyJSON,
        .{},
    );

    // Other
    var typeOther = std.json.Scanner.initCompleteInput(
        testing.allocator,
        "\"other\"",
    );

    defer typeOther.deinit();

    const actualOther = try imgtype.jsonParse(
        testing.allocator,
        &typeOther,
        .{},
    );

    // tests
    try testing.expectEqual(imgtype.Descriptor, actualDesc);
    try testing.expectEqual(imgtype.LayoutHeader, actualLayoutHeader);
    try testing.expectEqual(imgtype.ImageManifest, actualImageManifest);
    try testing.expectEqual(imgtype.ImageIndex, actualImageIndex);
    try testing.expectEqual(imgtype.ImageLayer, actualImageLayer);
    try testing.expectEqual(imgtype.ImageLayerGzip, actualImageLayerGzip);
    try testing.expectEqual(imgtype.ImageLayerZstd, actualImageLayerZstd);
    try testing.expectEqual(imgtype.ImageLayerNonDistributable, actualImageLayerNonDist);
    try testing.expectEqual(imgtype.ImageLayerNonDistributableGzip, actualImageLayerNonDistGzip);
    try testing.expectEqual(imgtype.ImageLayerNonDistributableZstd, actualImageLayerNonDistZstd);
    try testing.expectEqual(imgtype.ImageConfig, actualImageConfig);
    try testing.expectEqual(imgtype.ArtifactManifest, actualArtifactManifest);
    try testing.expectEqual(imgtype.EmptyJSON, actualEmptyJSON);
    try testing.expectEqual(imgtype.Other, actualOther);
}

test "image define MediaType jsonStringify" {
    // Descriptor
    var bufDesc = std.ArrayList(u8).init(testing.allocator);
    defer bufDesc.deinit();

    try imgtype.jsonStringify(&imgtype.Descriptor, bufDesc.writer());

    // LayoutHeader
    var bufLayoutHeader = std.ArrayList(u8).init(testing.allocator);
    defer bufLayoutHeader.deinit();

    try imgtype.jsonStringify(&imgtype.LayoutHeader, bufLayoutHeader.writer());

    // ImageManifest
    var bugImgManifest = std.ArrayList(u8).init(testing.allocator);
    defer bugImgManifest.deinit();

    try imgtype.jsonStringify(&imgtype.ImageManifest, bugImgManifest.writer());

    // ImageIndex
    var bufImgIndex = std.ArrayList(u8).init(testing.allocator);
    defer bufImgIndex.deinit();

    try imgtype.jsonStringify(&imgtype.ImageIndex, bufImgIndex.writer());

    // ImageLayer
    var bufImgLayer = std.ArrayList(u8).init(testing.allocator);
    defer bufImgLayer.deinit();

    try imgtype.jsonStringify(&imgtype.ImageLayer, bufImgLayer.writer());

    // ImageLayerGzip
    var bugImgLayerGzip = std.ArrayList(u8).init(testing.allocator);
    defer bugImgLayerGzip.deinit();

    try imgtype.jsonStringify(&imgtype.ImageLayerGzip, bugImgLayerGzip.writer());

    // ImageLayerZstd
    var bufImgLayerZstd = std.ArrayList(u8).init(testing.allocator);
    defer bufImgLayerZstd.deinit();

    try imgtype.jsonStringify(&imgtype.ImageLayerZstd, bufImgLayerZstd.writer());

    // ImageLayerNonDistributable
    var bufImgLayerNonDist = std.ArrayList(u8).init(testing.allocator);
    defer bufImgLayerNonDist.deinit();

    try imgtype.jsonStringify(&imgtype.ImageLayerNonDistributable, bufImgLayerNonDist.writer());

    // ImageLayerNonDistributableGzip
    var bufImgLayerNonDistGzip = std.ArrayList(u8).init(testing.allocator);
    defer bufImgLayerNonDistGzip.deinit();

    try imgtype.jsonStringify(&imgtype.ImageLayerNonDistributableGzip, bufImgLayerNonDistGzip.writer());

    // ImageLayerNonDistributableZstd
    var bufImgLayerNonDistZstd = std.ArrayList(u8).init(testing.allocator);
    defer bufImgLayerNonDistZstd.deinit();

    try imgtype.jsonStringify(&imgtype.ImageLayerNonDistributableZstd, bufImgLayerNonDistZstd.writer());

    // ImageConfig
    var bufImgConfig = std.ArrayList(u8).init(testing.allocator);
    defer bufImgConfig.deinit();

    try imgtype.jsonStringify(&imgtype.ImageConfig, bufImgConfig.writer());

    // ArtifactManifest
    var bufArtManifest = std.ArrayList(u8).init(testing.allocator);
    defer bufArtManifest.deinit();

    try imgtype.jsonStringify(&imgtype.ArtifactManifest, bufArtManifest.writer());

    // EmptyJSON
    var bufEmptyJson = std.ArrayList(u8).init(testing.allocator);
    defer bufEmptyJson.deinit();

    try imgtype.jsonStringify(&imgtype.EmptyJSON, bufEmptyJson.writer());

    // Other
    var bufOther = std.ArrayList(u8).init(testing.allocator);
    defer bufOther.deinit();

    try imgtype.jsonStringify(&imgtype.Other, bufOther.writer());

    // test
    try testing.expectEqualStrings(bufDesc.items, "\"application/vnd.oci.descriptor\"");
    try testing.expectEqualStrings(bufLayoutHeader.items, "\"application/vnd.oci.layout.header.v1+json\"");
    try testing.expectEqualStrings(bugImgManifest.items, "\"application/vnd.oci.image.manifest.v1+json\"");
    try testing.expectEqualStrings(bufImgIndex.items, "\"application/vnd.oci.image.index.v1+json\"");
    try testing.expectEqualStrings(bufImgLayer.items, "\"application/vnd.oci.image.layer.v1.tar\"");
    try testing.expectEqualStrings(bugImgLayerGzip.items, "\"application/vnd.oci.image.layer.v1.tar+gzip\"");
    try testing.expectEqualStrings(bufImgLayerZstd.items, "\"application/vnd.oci.image.layer.v1.tar+zstd\"");
    try testing.expectEqualStrings(bufImgLayerNonDist.items, "\"application/vnd.oci.image.layer.nondistributable.v1.tar\"");
    try testing.expectEqualStrings(bufImgLayerNonDistGzip.items, "\"application/vnd.oci.image.layer.nondistributable.v1.tar+gzip\"");
    try testing.expectEqualStrings(bufImgLayerNonDistZstd.items, "\"application/vnd.oci.image.layer.nondistributable.v1.tar+zstd\"");
    try testing.expectEqualStrings(bufImgConfig.items, "\"application/vnd.oci.image.config.v1+json\"");
    try testing.expectEqualStrings(bufArtManifest.items, "\"application/vnd.oci.artifact.manifest.v1+json\"");
    try testing.expectEqualStrings(bufEmptyJson.items, "\"application/vnd.oci.empty.v1+json\"");
    try testing.expectEqualStrings(bufOther.items, "\"other\"");
}
