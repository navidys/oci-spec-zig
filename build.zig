const std = @import("std");

pub fn build(b: *std.Build) void {
    if (comptime !checkVersion())
        @compileError("Please! Update zig toolchain >= 0.13!");

    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // add library
    const lib = b.addStaticLibrary(.{
        .name = "oci-spec",
        // In this case the main source file is merely a path, however, in more
        // complicated build scripts, this could be a generated file.
        .root_source_file = b.path("src/lib.zig"),
        .target = target,
        .optimize = optimize,
        .single_threaded = false,
    });

    b.installArtifact(lib);

    const oci_spec_module = b.addModule("oci-spec", .{
        .root_source_file = b.path("src/lib.zig"),
    });

    // step generate docs
    const install_docs = b.addInstallDirectory(.{
        .source_dir = lib.getEmittedDocs(),
        .install_dir = .prefix,
        .install_subdir = "docs",
    });
    const docs_step = b.step("docs", "Install docs into zig-out/docs");
    docs_step.dependOn(&install_docs.step);

    // build examples
    for ([_][]const u8{
        "image_config",
        "image_oci_layout",
        "image_manifest",
        "image_index",
        "artifact_manifest",
        "runtime_config",
    }) |example_name| {
        const example = b.addExecutable(.{
            .name = example_name,
            .root_source_file = b.path(b.fmt("examples/{s}.zig", .{example_name})),
            .target = target,
            .optimize = optimize,
        });

        example.root_module.addImport("oci-spec", oci_spec_module);
        b.installArtifact(example);
    }

    // step run tests
    const lib_unit_tests = b.addTest(.{
        // Assuming this needs to be the same root file as the library,
        // since it's the library we're building tests for?
        .root_source_file = b.path("tests/lib.zig"),
        .target = target,
        .optimize = optimize,
    });
    lib_unit_tests.root_module.addImport("oci-spec", oci_spec_module);

    const run_lib_unit_tests = b.addRunArtifact(lib_unit_tests);

    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_lib_unit_tests.step);

    // step generate code cov
    const cov_step = b.step("cov", "Generate code coverage");

    const cov_run = b.addSystemCommand(&.{ "kcov", "--clean", "--include-pattern=src/", ".coverage/" });
    cov_run.addArtifactArg(lib_unit_tests);

    cov_step.dependOn(&cov_run.step);

    // step check formatting
    const fmt_step = b.step("fmt", "Check formatting");

    const fmt = b.addFmt(.{
        .paths = &.{
            "src/",
            "build.zig",
            "build.zig.zon",
        },
        .check = true,
    });

    fmt_step.dependOn(&fmt.step);
}

fn checkVersion() bool {
    const builtin = @import("builtin");
    if (!@hasDecl(builtin, "zig_version")) {
        return false;
    }

    const needed_version = std.SemanticVersion.parse("0.13.0") catch unreachable;
    const version = builtin.zig_version;
    const order = version.order(needed_version);
    return order != .lt;
}
