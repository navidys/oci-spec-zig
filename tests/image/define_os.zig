const std = @import("std");
const ocispec = @import("ocispec");
const osimage = ocispec.image.OS;
const testing = std.testing;

test "image define OS jsonStringify" {
    // AIX
    var osAIXBuf = std.ArrayList(u8).init(testing.allocator);
    defer osAIXBuf.deinit();

    try osimage.jsonStringify(&osimage.AIX, osAIXBuf.writer());

    // Android
    var osAndroidBuf = std.ArrayList(u8).init(testing.allocator);
    defer osAndroidBuf.deinit();

    try osimage.jsonStringify(&osimage.Android, osAndroidBuf.writer());

    // Darwin
    var osDarwinBuf = std.ArrayList(u8).init(testing.allocator);
    defer osDarwinBuf.deinit();

    try osimage.jsonStringify(&osimage.Darwin, osDarwinBuf.writer());

    // DragonFlyBSD
    var osDragonflyBuf = std.ArrayList(u8).init(testing.allocator);
    defer osDragonflyBuf.deinit();

    try osimage.jsonStringify(&osimage.DragonFlyBSD, osDragonflyBuf.writer());

    // FreeBSD
    var osFreeBSDBuf = std.ArrayList(u8).init(testing.allocator);
    defer osFreeBSDBuf.deinit();

    try osimage.jsonStringify(&osimage.FreeBSD, osFreeBSDBuf.writer());

    // Hurd
    var osHurdBuf = std.ArrayList(u8).init(testing.allocator);
    defer osHurdBuf.deinit();

    try osimage.jsonStringify(&osimage.Hurd, osHurdBuf.writer());

    // Illumos
    var osIllumosBuf = std.ArrayList(u8).init(testing.allocator);
    defer osIllumosBuf.deinit();

    try osimage.jsonStringify(&osimage.Illumos, osIllumosBuf.writer());

    // IOS
    var osIOSBuf = std.ArrayList(u8).init(testing.allocator);
    defer osIOSBuf.deinit();

    try osimage.jsonStringify(&osimage.IOS, osIOSBuf.writer());

    // Js
    var osJsBuf = std.ArrayList(u8).init(testing.allocator);
    defer osJsBuf.deinit();

    try osimage.jsonStringify(&osimage.Js, osJsBuf.writer());

    // Linux
    var osLinuxBuf = std.ArrayList(u8).init(testing.allocator);
    defer osLinuxBuf.deinit();

    try osimage.jsonStringify(&osimage.Linux, osLinuxBuf.writer());

    // Nacl
    var osNaclBuf = std.ArrayList(u8).init(testing.allocator);
    defer osNaclBuf.deinit();

    try osimage.jsonStringify(&osimage.Nacl, osNaclBuf.writer());

    // NetBSD
    var osNetBSDBuf = std.ArrayList(u8).init(testing.allocator);
    defer osNetBSDBuf.deinit();

    try osimage.jsonStringify(&osimage.NetBSD, osNetBSDBuf.writer());

    // OpenBSD
    var osOpenBSDBuf = std.ArrayList(u8).init(testing.allocator);
    defer osOpenBSDBuf.deinit();

    try osimage.jsonStringify(&osimage.OpenBSD, osOpenBSDBuf.writer());

    // Plan9
    var osPlan9Buf = std.ArrayList(u8).init(testing.allocator);
    defer osPlan9Buf.deinit();

    try osimage.jsonStringify(&osimage.Plan9, osPlan9Buf.writer());

    // Solaris
    var osSolarisBuf = std.ArrayList(u8).init(testing.allocator);
    defer osSolarisBuf.deinit();

    try osimage.jsonStringify(&osimage.Solaris, osSolarisBuf.writer());

    // Windows
    var osWindowsBuf = std.ArrayList(u8).init(testing.allocator);
    defer osWindowsBuf.deinit();

    try osimage.jsonStringify(&osimage.Windows, osWindowsBuf.writer());

    // ZOS
    var osZOSBuf = std.ArrayList(u8).init(testing.allocator);
    defer osZOSBuf.deinit();

    try osimage.jsonStringify(&osimage.ZOS, osZOSBuf.writer());

    // Other
    var osOtherBuf = std.ArrayList(u8).init(testing.allocator);
    defer osOtherBuf.deinit();

    try osimage.jsonStringify(&osimage.Other, osOtherBuf.writer());

    // test
    try testing.expectEqualStrings(osAIXBuf.items, "\"aix\"");
    try testing.expectEqualStrings(osAndroidBuf.items, "\"android\"");
    try testing.expectEqualStrings(osDarwinBuf.items, "\"darwin\"");
    try testing.expectEqualStrings(osDragonflyBuf.items, "\"dragonfly\"");
    try testing.expectEqualStrings(osFreeBSDBuf.items, "\"freebsd\"");
    try testing.expectEqualStrings(osHurdBuf.items, "\"hurd\"");
    try testing.expectEqualStrings(osIllumosBuf.items, "\"illumos\"");
    try testing.expectEqualStrings(osIOSBuf.items, "\"ios\"");
    try testing.expectEqualStrings(osJsBuf.items, "\"js\"");
    try testing.expectEqualStrings(osLinuxBuf.items, "\"linux\"");
    try testing.expectEqualStrings(osNaclBuf.items, "\"nacl\"");
    try testing.expectEqualStrings(osNetBSDBuf.items, "\"netbsd\"");
    try testing.expectEqualStrings(osOpenBSDBuf.items, "\"openbsd\"");
    try testing.expectEqualStrings(osPlan9Buf.items, "\"plan9\"");
    try testing.expectEqualStrings(osSolarisBuf.items, "\"solaris\"");
    try testing.expectEqualStrings(osWindowsBuf.items, "\"windows\"");
    try testing.expectEqualStrings(osZOSBuf.items, "\"zos\"");
    try testing.expectEqualStrings(osOtherBuf.items, "\"other\"");
}

test "image define OS jsonParse" {
    // AIX
    var osAIX = std.json.Scanner.initCompleteInput(
        testing.allocator,
        "\"aix\"",
    );

    defer osAIX.deinit();

    const osAIXActual = try osimage.jsonParse(testing.allocator, &osAIX, .{});

    // Android
    var osAndroid = std.json.Scanner.initCompleteInput(
        testing.allocator,
        "\"android\"",
    );

    defer osAndroid.deinit();

    const osAndroidActual = try osimage.jsonParse(
        testing.allocator,
        &osAndroid,
        .{},
    );

    // Darwin
    var osDarwin = std.json.Scanner.initCompleteInput(
        testing.allocator,
        "\"darwin\"",
    );

    defer osDarwin.deinit();

    const osDarwinActual = try osimage.jsonParse(
        testing.allocator,
        &osDarwin,
        .{},
    );

    // DragonFlyBSD
    var osDragonfly = std.json.Scanner.initCompleteInput(
        testing.allocator,
        "\"dragonfly\"",
    );

    defer osDragonfly.deinit();

    const osDragonflyActual = try osimage.jsonParse(
        testing.allocator,
        &osDragonfly,
        .{},
    );

    // FreeBSD
    var osFreeBSD = std.json.Scanner.initCompleteInput(
        testing.allocator,
        "\"freebsd\"",
    );

    defer osFreeBSD.deinit();

    const osFreeBSDActual = try osimage.jsonParse(
        testing.allocator,
        &osFreeBSD,
        .{},
    );

    // Hurd
    var osHurd = std.json.Scanner.initCompleteInput(
        testing.allocator,
        "\"hurd\"",
    );

    defer osHurd.deinit();

    const osHurdActual = try osimage.jsonParse(
        testing.allocator,
        &osHurd,
        .{},
    );

    // Illumos
    var osIllumos = std.json.Scanner.initCompleteInput(
        testing.allocator,
        "\"illumos\"",
    );

    defer osIllumos.deinit();

    const osIllumosActual = try osimage.jsonParse(
        testing.allocator,
        &osIllumos,
        .{},
    );

    // IOS
    var osIOS = std.json.Scanner.initCompleteInput(
        testing.allocator,
        "\"ios\"",
    );

    defer osIOS.deinit();

    const osIOSActual = try osimage.jsonParse(
        testing.allocator,
        &osIOS,
        .{},
    );

    // Js
    var osJs = std.json.Scanner.initCompleteInput(
        testing.allocator,
        "\"js\"",
    );

    defer osJs.deinit();

    const osJsActual = try osimage.jsonParse(
        testing.allocator,
        &osJs,
        .{},
    );

    // Linux
    var osLinux = std.json.Scanner.initCompleteInput(
        testing.allocator,
        "\"linux\"",
    );

    defer osLinux.deinit();

    const osLinuxActual = try osimage.jsonParse(
        testing.allocator,
        &osLinux,
        .{},
    );

    // Nacl
    var osNacl = std.json.Scanner.initCompleteInput(
        testing.allocator,
        "\"nacl\"",
    );

    defer osNacl.deinit();

    const osNaclActual = try osimage.jsonParse(
        testing.allocator,
        &osNacl,
        .{},
    );

    // NetBSD
    var osNetBSD = std.json.Scanner.initCompleteInput(
        testing.allocator,
        "\"netbsd\"",
    );

    defer osNetBSD.deinit();

    const osNetBSDActual = try osimage.jsonParse(
        testing.allocator,
        &osNetBSD,
        .{},
    );

    // OpenBSD
    var osOpenBSD = std.json.Scanner.initCompleteInput(
        testing.allocator,
        "\"openbsd\"",
    );

    defer osOpenBSD.deinit();

    const osOpenBSDActual = try osimage.jsonParse(
        testing.allocator,
        &osOpenBSD,
        .{},
    );

    // Plan9
    var osPlan9 = std.json.Scanner.initCompleteInput(
        testing.allocator,
        "\"plan9\"",
    );

    defer osPlan9.deinit();

    const osPlan9Actual = try osimage.jsonParse(
        testing.allocator,
        &osPlan9,
        .{},
    );

    // Solaris
    var osSolaris = std.json.Scanner.initCompleteInput(
        testing.allocator,
        "\"solaris\"",
    );

    defer osSolaris.deinit();

    const osSolarisActual = try osimage.jsonParse(
        testing.allocator,
        &osSolaris,
        .{},
    );

    // Windows
    var osWindows = std.json.Scanner.initCompleteInput(
        testing.allocator,
        "\"windows\"",
    );

    defer osWindows.deinit();

    const osWindowsActual = try osimage.jsonParse(
        testing.allocator,
        &osWindows,
        .{},
    );

    // ZOS
    var osZOS = std.json.Scanner.initCompleteInput(
        testing.allocator,
        "\"zos\"",
    );

    defer osZOS.deinit();

    const osZOSActual = try osimage.jsonParse(
        testing.allocator,
        &osZOS,
        .{},
    );

    // Other
    var osOther = std.json.Scanner.initCompleteInput(
        testing.allocator,
        "\"other\"",
    );

    defer osOther.deinit();

    const osOtherActual = try osimage.jsonParse(
        testing.allocator,
        &osOther,
        .{},
    );

    // tests

    try testing.expectEqual(osimage.AIX, osAIXActual);
    try testing.expectEqual(osimage.Android, osAndroidActual);
    try testing.expectEqual(osimage.Darwin, osDarwinActual);
    try testing.expectEqual(osimage.DragonFlyBSD, osDragonflyActual);
    try testing.expectEqual(osimage.FreeBSD, osFreeBSDActual);
    try testing.expectEqual(osimage.Hurd, osHurdActual);
    try testing.expectEqual(osimage.Illumos, osIllumosActual);
    try testing.expectEqual(osimage.IOS, osIOSActual);
    try testing.expectEqual(osimage.Js, osJsActual);
    try testing.expectEqual(osimage.Linux, osLinuxActual);
    try testing.expectEqual(osimage.Nacl, osNaclActual);
    try testing.expectEqual(osimage.NetBSD, osNetBSDActual);
    try testing.expectEqual(osimage.OpenBSD, osOpenBSDActual);
    try testing.expectEqual(osimage.Plan9, osPlan9Actual);
    try testing.expectEqual(osimage.Solaris, osSolarisActual);
    try testing.expectEqual(osimage.Windows, osWindowsActual);
    try testing.expectEqual(osimage.ZOS, osZOSActual);
    try testing.expectEqual(osimage.Other, osOtherActual);
}
