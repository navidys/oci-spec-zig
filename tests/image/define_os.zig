const std = @import("std");
const ocispec = @import("ocispec");
const osimage = ocispec.image.OS;
const testing = std.testing;

test "image define OS jsonStringify" {
    // AIX
    var osAIXBuf: std.ArrayList(u8) = .{};
    defer osAIXBuf.deinit(testing.allocator);

    try osimage.jsonStringify(&osimage.AIX, osAIXBuf.writer(testing.allocator));

    // Android
    var osAndroidBuf: std.ArrayList(u8) = .{};
    defer osAndroidBuf.deinit(testing.allocator);

    try osimage.jsonStringify(&osimage.Android, osAndroidBuf.writer(testing.allocator));

    // Darwin
    var osDarwinBuf: std.ArrayList(u8) = .{};
    defer osDarwinBuf.deinit(testing.allocator);

    try osimage.jsonStringify(&osimage.Darwin, osDarwinBuf.writer(testing.allocator));

    // DragonFlyBSD
    var osDragonflyBuf: std.ArrayList(u8) = .{};
    defer osDragonflyBuf.deinit(testing.allocator);

    try osimage.jsonStringify(&osimage.DragonFlyBSD, osDragonflyBuf.writer(testing.allocator));

    // FreeBSD
    var osFreeBSDBuf: std.ArrayList(u8) = .{};
    defer osFreeBSDBuf.deinit(testing.allocator);

    try osimage.jsonStringify(&osimage.FreeBSD, osFreeBSDBuf.writer(testing.allocator));

    // Hurd
    var osHurdBuf: std.ArrayList(u8) = .{};
    defer osHurdBuf.deinit(testing.allocator);

    try osimage.jsonStringify(&osimage.Hurd, osHurdBuf.writer(testing.allocator));

    // Illumos
    var osIllumosBuf: std.ArrayList(u8) = .{};
    defer osIllumosBuf.deinit(testing.allocator);

    try osimage.jsonStringify(&osimage.Illumos, osIllumosBuf.writer(testing.allocator));

    // IOS
    var osIOSBuf: std.ArrayList(u8) = .{};
    defer osIOSBuf.deinit(testing.allocator);

    try osimage.jsonStringify(&osimage.IOS, osIOSBuf.writer(testing.allocator));

    // Js
    var osJsBuf: std.ArrayList(u8) = .{};
    defer osJsBuf.deinit(testing.allocator);

    try osimage.jsonStringify(&osimage.Js, osJsBuf.writer(testing.allocator));

    // Linux
    var osLinuxBuf: std.ArrayList(u8) = .{};
    defer osLinuxBuf.deinit(testing.allocator);

    try osimage.jsonStringify(&osimage.Linux, osLinuxBuf.writer(testing.allocator));

    // Nacl
    var osNaclBuf: std.ArrayList(u8) = .{};
    defer osNaclBuf.deinit(testing.allocator);

    try osimage.jsonStringify(&osimage.Nacl, osNaclBuf.writer(testing.allocator));

    // NetBSD
    var osNetBSDBuf: std.ArrayList(u8) = .{};
    defer osNetBSDBuf.deinit(testing.allocator);

    try osimage.jsonStringify(&osimage.NetBSD, osNetBSDBuf.writer(testing.allocator));

    // OpenBSD
    var osOpenBSDBuf: std.ArrayList(u8) = .{};
    defer osOpenBSDBuf.deinit(testing.allocator);

    try osimage.jsonStringify(&osimage.OpenBSD, osOpenBSDBuf.writer(testing.allocator));

    // Plan9
    var osPlan9Buf: std.ArrayList(u8) = .{};
    defer osPlan9Buf.deinit(testing.allocator);

    try osimage.jsonStringify(&osimage.Plan9, osPlan9Buf.writer(testing.allocator));

    // Solaris
    var osSolarisBuf: std.ArrayList(u8) = .{};
    defer osSolarisBuf.deinit(testing.allocator);

    try osimage.jsonStringify(&osimage.Solaris, osSolarisBuf.writer(testing.allocator));

    // Windows
    var osWindowsBuf: std.ArrayList(u8) = .{};
    defer osWindowsBuf.deinit(testing.allocator);

    try osimage.jsonStringify(&osimage.Windows, osWindowsBuf.writer(testing.allocator));

    // ZOS
    var osZOSBuf: std.ArrayList(u8) = .{};
    defer osZOSBuf.deinit(testing.allocator);

    try osimage.jsonStringify(&osimage.ZOS, osZOSBuf.writer(testing.allocator));

    // Other
    var osOtherBuf: std.ArrayList(u8) = .{};
    defer osOtherBuf.deinit(testing.allocator);

    try osimage.jsonStringify(&osimage.Other, osOtherBuf.writer(testing.allocator));

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
