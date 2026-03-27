const std = @import("std");

const MIN_ZIG_VERSION = "0.14.1";

pub fn build(b: *std.Build) void {
    if (comptime !checkVersion())
        @compileError("Please! Update zig toolchain >= 0.14.1!");

    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const oci_spec_module = b.addModule("ocispec", .{
        .root_source_file = b.path("src/lib.zig"),
    });

    // Library object for documentation generation
    const lib = b.addObject(.{
        .name = "ocispec",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/lib.zig"),
            .target = target,
            .optimize = optimize,
        }),
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
            .root_module = b.createModule(.{
                .root_source_file = b.path(b.fmt("examples/{s}.zig", .{example_name})),
                .target = target,
                .optimize = optimize,
            }),
        });

        example.root_module.addImport("ocispec", oci_spec_module);
        b.installArtifact(example);
    }

    // step run tests
    const test_module = b.createModule(.{
        .root_source_file = b.path("tests/lib.zig"),
        .target = target,
        .optimize = optimize,
    });
    test_module.addImport("ocispec", oci_spec_module);
    const lib_unit_tests = b.addTest(.{
        .root_module = test_module,
    });

    const run_lib_unit_tests = b.addRunArtifact(lib_unit_tests);

    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_lib_unit_tests.step);

    // step generate code coverage
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

    const needed_version = std.SemanticVersion.parse(MIN_ZIG_VERSION) catch unreachable;
    const version = builtin.zig_version;
    const order = version.order(needed_version);
    return order != .lt;
}
