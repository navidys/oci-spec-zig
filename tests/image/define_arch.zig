const std = @import("std");
const ocispec = @import("ocispec");
const arch = ocispec.image.Arch;
const testing = std.testing;

test "image define Arch jsonStringify" {
    // I386
    var archI386Buf = std.ArrayList(u8).init(testing.allocator);
    defer archI386Buf.deinit();

    try arch.jsonStringify(&arch.I386, archI386Buf.writer());

    // Amd64
    var archAmd64Buf = std.ArrayList(u8).init(testing.allocator);
    defer archAmd64Buf.deinit();

    try arch.jsonStringify(&arch.Amd64, archAmd64Buf.writer());

    // Amd64p32
    var archAmd64p32Buf = std.ArrayList(u8).init(testing.allocator);
    defer archAmd64p32Buf.deinit();

    try arch.jsonStringify(&arch.Amd64p32, archAmd64p32Buf.writer());

    // ARM
    var archARMBuf = std.ArrayList(u8).init(testing.allocator);
    defer archARMBuf.deinit();

    try arch.jsonStringify(&arch.ARM, archARMBuf.writer());

    // ARMbe
    var archARMbeBuf = std.ArrayList(u8).init(testing.allocator);
    defer archARMbeBuf.deinit();

    try arch.jsonStringify(&arch.ARMbe, archARMbeBuf.writer());

    // ARM64
    var archARM64Buf = std.ArrayList(u8).init(testing.allocator);
    defer archARM64Buf.deinit();

    try arch.jsonStringify(&arch.ARM64, archARM64Buf.writer());

    // ARM64be
    var archARM64beBuf = std.ArrayList(u8).init(testing.allocator);
    defer archARM64beBuf.deinit();

    try arch.jsonStringify(&arch.ARM64be, archARM64beBuf.writer());

    // LoongArch64
    var archLoongArch64Buf = std.ArrayList(u8).init(testing.allocator);
    defer archLoongArch64Buf.deinit();

    try arch.jsonStringify(&arch.LoongArch64, archLoongArch64Buf.writer());

    // Mips
    var archMipsBuf = std.ArrayList(u8).init(testing.allocator);
    defer archMipsBuf.deinit();

    try arch.jsonStringify(&arch.Mips, archMipsBuf.writer());

    // Mipsle
    var archMipsleBuf = std.ArrayList(u8).init(testing.allocator);
    defer archMipsleBuf.deinit();

    try arch.jsonStringify(&arch.Mipsle, archMipsleBuf.writer());

    // Mips64
    var archMips64Buf = std.ArrayList(u8).init(testing.allocator);
    defer archMips64Buf.deinit();

    try arch.jsonStringify(&arch.Mips64, archMips64Buf.writer());

    // Mips64le
    var archMips64leBuf = std.ArrayList(u8).init(testing.allocator);
    defer archMips64leBuf.deinit();

    try arch.jsonStringify(&arch.Mips64le, archMips64leBuf.writer());

    // Mips64p32
    var archMips64p32Buf = std.ArrayList(u8).init(testing.allocator);
    defer archMips64p32Buf.deinit();

    try arch.jsonStringify(&arch.Mips64p32, archMips64p32Buf.writer());

    // Mips64p32le
    var archMips64p32leBuf = std.ArrayList(u8).init(testing.allocator);
    defer archMips64p32leBuf.deinit();

    try arch.jsonStringify(&arch.Mips64p32le, archMips64p32leBuf.writer());

    // PowerPC
    var archPowerPCBuf = std.ArrayList(u8).init(testing.allocator);
    defer archPowerPCBuf.deinit();

    try arch.jsonStringify(&arch.PowerPC, archPowerPCBuf.writer());

    // PowerPC64
    var archPowerPC64Buf = std.ArrayList(u8).init(testing.allocator);
    defer archPowerPC64Buf.deinit();

    try arch.jsonStringify(&arch.PowerPC64, archPowerPC64Buf.writer());

    // PowerPC64le
    var archPowerPC64leBuf = std.ArrayList(u8).init(testing.allocator);
    defer archPowerPC64leBuf.deinit();

    try arch.jsonStringify(&arch.PowerPC64le, archPowerPC64leBuf.writer());

    // RISCV
    var archRISCVBuf = std.ArrayList(u8).init(testing.allocator);
    defer archRISCVBuf.deinit();

    try arch.jsonStringify(&arch.RISCV, archRISCVBuf.writer());

    // RISCV64
    var archRISCV64Buf = std.ArrayList(u8).init(testing.allocator);
    defer archRISCV64Buf.deinit();

    try arch.jsonStringify(&arch.RISCV64, archRISCV64Buf.writer());

    // S390
    var archS390Buf = std.ArrayList(u8).init(testing.allocator);
    defer archS390Buf.deinit();

    try arch.jsonStringify(&arch.S390, archS390Buf.writer());

    // S390x
    var archS390xBuf = std.ArrayList(u8).init(testing.allocator);
    defer archS390xBuf.deinit();

    try arch.jsonStringify(&arch.S390x, archS390xBuf.writer());

    // SPARC
    var archSPARCBuf = std.ArrayList(u8).init(testing.allocator);
    defer archSPARCBuf.deinit();

    try arch.jsonStringify(&arch.SPARC, archSPARCBuf.writer());

    // SPARC64
    var archSPARC64Buf = std.ArrayList(u8).init(testing.allocator);
    defer archSPARC64Buf.deinit();

    try arch.jsonStringify(&arch.SPARC64, archSPARC64Buf.writer());

    // Wasm
    var archWasmBuf = std.ArrayList(u8).init(testing.allocator);
    defer archWasmBuf.deinit();

    try arch.jsonStringify(&arch.Wasm, archWasmBuf.writer());

    // Other
    var archOtherBuf = std.ArrayList(u8).init(testing.allocator);
    defer archOtherBuf.deinit();

    try arch.jsonStringify(&arch.Other, archOtherBuf.writer());

    // test
    try testing.expectEqualStrings(archI386Buf.items, "\"386\"");
    try testing.expectEqualStrings(archAmd64Buf.items, "\"amd64\"");
    try testing.expectEqualStrings(archAmd64p32Buf.items, "\"amd64p32\"");
    try testing.expectEqualStrings(archARMBuf.items, "\"arm\"");
    try testing.expectEqualStrings(archARMbeBuf.items, "\"armbe\"");
    try testing.expectEqualStrings(archARM64Buf.items, "\"arm64\"");
    try testing.expectEqualStrings(archARM64beBuf.items, "\"arm64be\"");
    try testing.expectEqualStrings(archLoongArch64Buf.items, "\"loong64\"");
    try testing.expectEqualStrings(archMipsBuf.items, "\"mips\"");
    try testing.expectEqualStrings(archMipsleBuf.items, "\"mipsle\"");
    try testing.expectEqualStrings(archMips64Buf.items, "\"mips64\"");
    try testing.expectEqualStrings(archMips64leBuf.items, "\"mips64le\"");
    try testing.expectEqualStrings(archMips64p32Buf.items, "\"mips64p32\"");
    try testing.expectEqualStrings(archMips64p32leBuf.items, "\"mips64p32le\"");
    try testing.expectEqualStrings(archPowerPCBuf.items, "\"ppc\"");
    try testing.expectEqualStrings(archPowerPC64Buf.items, "\"ppc64\"");
    try testing.expectEqualStrings(archPowerPC64leBuf.items, "\"ppc64le\"");
    try testing.expectEqualStrings(archRISCVBuf.items, "\"riscv\"");
    try testing.expectEqualStrings(archRISCV64Buf.items, "\"riscv64\"");
    try testing.expectEqualStrings(archS390Buf.items, "\"s390\"");
    try testing.expectEqualStrings(archS390xBuf.items, "\"s390x\"");
    try testing.expectEqualStrings(archSPARCBuf.items, "\"sparc\"");
    try testing.expectEqualStrings(archSPARC64Buf.items, "\"sparc64\"");
    try testing.expectEqualStrings(archWasmBuf.items, "\"wasm\"");
    try testing.expectEqualStrings(archOtherBuf.items, "\"other\"");
}

test "image define Arch jsonParse" {
    // I386
    var archI386 = std.json.Scanner.initCompleteInput(
        testing.allocator,
        "\"386\"",
    );

    defer archI386.deinit();

    const archI386Actual = try arch.jsonParse(testing.allocator, &archI386, .{});

    // Amd64
    var archAmd64 = std.json.Scanner.initCompleteInput(
        testing.allocator,
        "\"amd64\"",
    );

    defer archAmd64.deinit();

    const archAmd64Actual = try arch.jsonParse(testing.allocator, &archAmd64, .{});

    // Amd64p32
    var archAmd64p32 = std.json.Scanner.initCompleteInput(
        testing.allocator,
        "\"amd64p32\"",
    );

    defer archAmd64p32.deinit();

    const archAmd64p32Actual = try arch.jsonParse(testing.allocator, &archAmd64p32, .{});

    // ARM
    var archARM = std.json.Scanner.initCompleteInput(
        testing.allocator,
        "\"arm\"",
    );

    defer archARM.deinit();

    const archARMActual = try arch.jsonParse(testing.allocator, &archARM, .{});

    // ARMbe
    var archARMbe = std.json.Scanner.initCompleteInput(
        testing.allocator,
        "\"armbe\"",
    );

    defer archARMbe.deinit();

    const archARMbeActual = try arch.jsonParse(testing.allocator, &archARMbe, .{});

    // ARM64
    var archARM64 = std.json.Scanner.initCompleteInput(
        testing.allocator,
        "\"arm64\"",
    );

    defer archARM64.deinit();

    const archARM64Actual = try arch.jsonParse(testing.allocator, &archARM64, .{});

    // ARM64be
    var archARM64be = std.json.Scanner.initCompleteInput(
        testing.allocator,
        "\"arm64be\"",
    );

    defer archARM64be.deinit();

    const archARM64beActual = try arch.jsonParse(testing.allocator, &archARM64be, .{});

    // LoongArch64
    var archLoongArch64 = std.json.Scanner.initCompleteInput(
        testing.allocator,
        "\"loong64\"",
    );

    defer archLoongArch64.deinit();

    const archLoongArch64Actual = try arch.jsonParse(testing.allocator, &archLoongArch64, .{});

    // Mips
    var archMips = std.json.Scanner.initCompleteInput(
        testing.allocator,
        "\"mips\"",
    );

    defer archMips.deinit();

    const archMipsActual = try arch.jsonParse(testing.allocator, &archMips, .{});

    // Mipsle
    var archMipsle = std.json.Scanner.initCompleteInput(
        testing.allocator,
        "\"mipsle\"",
    );

    defer archMipsle.deinit();

    const archMipsleActual = try arch.jsonParse(testing.allocator, &archMipsle, .{});

    // Mips64
    var archMips64 = std.json.Scanner.initCompleteInput(
        testing.allocator,
        "\"mips64\"",
    );

    defer archMips64.deinit();

    const archMips64Actual = try arch.jsonParse(testing.allocator, &archMips64, .{});

    // Mips64le
    var archMips64le = std.json.Scanner.initCompleteInput(
        testing.allocator,
        "\"mips64le\"",
    );

    defer archMips64le.deinit();

    const archMips64leActual = try arch.jsonParse(testing.allocator, &archMips64le, .{});

    // Mips64p32
    var archMips64p32 = std.json.Scanner.initCompleteInput(
        testing.allocator,
        "\"mips64p32\"",
    );

    defer archMips64p32.deinit();

    const archMips64p32Actual = try arch.jsonParse(testing.allocator, &archMips64p32, .{});

    // Mips64p32le
    var archMips64p32le = std.json.Scanner.initCompleteInput(
        testing.allocator,
        "\"mips64p32le\"",
    );

    defer archMips64p32le.deinit();

    const archMips64p32leActual = try arch.jsonParse(testing.allocator, &archMips64p32le, .{});

    // PowerPC
    var archPowerPC = std.json.Scanner.initCompleteInput(
        testing.allocator,
        "\"ppc\"",
    );

    defer archPowerPC.deinit();

    const archPowerPCActual = try arch.jsonParse(testing.allocator, &archPowerPC, .{});

    // PowerPC64
    var archPowerPC64 = std.json.Scanner.initCompleteInput(
        testing.allocator,
        "\"ppc64\"",
    );

    defer archPowerPC64.deinit();

    const archPowerPC64Actual = try arch.jsonParse(testing.allocator, &archPowerPC64, .{});

    // PowerPC64le
    var archPowerPC64le = std.json.Scanner.initCompleteInput(
        testing.allocator,
        "\"ppc64le\"",
    );

    defer archPowerPC64le.deinit();

    const archPowerPC64leActual = try arch.jsonParse(testing.allocator, &archPowerPC64le, .{});

    // RISCV
    var archRISCV = std.json.Scanner.initCompleteInput(
        testing.allocator,
        "\"riscv\"",
    );

    defer archRISCV.deinit();

    const archRISCVActual = try arch.jsonParse(testing.allocator, &archRISCV, .{});

    // RISCV64
    var archRISCV64 = std.json.Scanner.initCompleteInput(
        testing.allocator,
        "\"riscv64\"",
    );

    defer archRISCV64.deinit();

    const archRISCV64Actual = try arch.jsonParse(testing.allocator, &archRISCV64, .{});

    // S390
    var archS390 = std.json.Scanner.initCompleteInput(
        testing.allocator,
        "\"s390\"",
    );

    defer archS390.deinit();

    const archS390Actual = try arch.jsonParse(testing.allocator, &archS390, .{});

    // S390x
    var archS390x = std.json.Scanner.initCompleteInput(
        testing.allocator,
        "\"s390x\"",
    );

    defer archS390x.deinit();

    const archS390xActual = try arch.jsonParse(testing.allocator, &archS390x, .{});

    // SPARC
    var archSPARC = std.json.Scanner.initCompleteInput(
        testing.allocator,
        "\"sparc\"",
    );

    defer archSPARC.deinit();

    const archSPARCActual = try arch.jsonParse(testing.allocator, &archSPARC, .{});

    // SPARC64
    var archSPARC64 = std.json.Scanner.initCompleteInput(
        testing.allocator,
        "\"sparc64\"",
    );

    defer archSPARC64.deinit();

    const archSPARC64Actual = try arch.jsonParse(testing.allocator, &archSPARC64, .{});

    // Wasm
    var archWasm = std.json.Scanner.initCompleteInput(
        testing.allocator,
        "\"wasm\"",
    );

    defer archWasm.deinit();

    const archWasmActual = try arch.jsonParse(testing.allocator, &archWasm, .{});

    // Other
    var archOther = std.json.Scanner.initCompleteInput(
        testing.allocator,
        "\"other\"",
    );

    defer archOther.deinit();

    const archOtherActual = try arch.jsonParse(testing.allocator, &archOther, .{});

    // tests
    try testing.expectEqual(arch.I386, archI386Actual);
    try testing.expectEqual(arch.Amd64, archAmd64Actual);
    try testing.expectEqual(arch.Amd64p32, archAmd64p32Actual);
    try testing.expectEqual(arch.ARM, archARMActual);
    try testing.expectEqual(arch.ARMbe, archARMbeActual);
    try testing.expectEqual(arch.ARM64, archARM64Actual);
    try testing.expectEqual(arch.ARM64be, archARM64beActual);
    try testing.expectEqual(arch.LoongArch64, archLoongArch64Actual);
    try testing.expectEqual(arch.Mips, archMipsActual);
    try testing.expectEqual(arch.Mipsle, archMipsleActual);
    try testing.expectEqual(arch.Mips64, archMips64Actual);
    try testing.expectEqual(arch.Mips64le, archMips64leActual);
    try testing.expectEqual(arch.Mips64p32, archMips64p32Actual);
    try testing.expectEqual(arch.Mips64p32le, archMips64p32leActual);
    try testing.expectEqual(arch.PowerPC, archPowerPCActual);
    try testing.expectEqual(arch.PowerPC64, archPowerPC64Actual);
    try testing.expectEqual(arch.PowerPC64le, archPowerPC64leActual);
    try testing.expectEqual(arch.RISCV, archRISCVActual);
    try testing.expectEqual(arch.RISCV64, archRISCV64Actual);
    try testing.expectEqual(arch.S390, archS390Actual);
    try testing.expectEqual(arch.S390x, archS390xActual);
    try testing.expectEqual(arch.SPARC, archSPARCActual);
    try testing.expectEqual(arch.SPARC64, archSPARC64Actual);
    try testing.expectEqual(arch.Wasm, archWasmActual);
    try testing.expectEqual(arch.Other, archOtherActual);
}
