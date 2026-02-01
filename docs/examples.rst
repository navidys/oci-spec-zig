Examples
=========

Runtime config (spec)
------------------------

.. code-block:: zig

    const std = @import("std");
    const ocispec = @import("ocispec");
    const runtime = ocispec.runtime;

    pub fn main() !void {
        var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
        defer arena.deinit();

        const allocator = arena.allocator();

        const file_path = "./tests/fixtures/runtime_spec.json";
        const spec = try runtime.Spec.initFromFile(allocator, file_path);

        const config_content = try spec.toStringPretty(allocator);

        const stdout_file = std.io.getStdOut().writer();
        var bw = std.io.bufferedWriter(stdout_file);
        const stdout = bw.writer();

        try stdout.print("{s}\n", .{config_content});

        try bw.flush();
    }


Image config
------------------------

.. code-block:: zig

    const std = @import("std");
    const ocispec = @import("ocispec");
    const image = ocispec.image;

    pub fn main() !void {
        var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
        defer arena.deinit();

        const allocator = arena.allocator();

        const file_path = "./tests/fixtures/config.json";
        const image_config = try image.Configuration.initFromFile(allocator, file_path);
        const config_content = try image_config.toStringPretty(allocator);

        const stdout_file = std.io.getStdOut().writer();
        var bw = std.io.bufferedWriter(stdout_file);
        const stdout = bw.writer();

        try stdout.print("{s}\n", .{config_content});

        try bw.flush();
    }


Image index
------------------------

.. code-block:: zig

    const std = @import("std");
    const ocispec = @import("ocispec");
    const image = ocispec.image;

    pub fn main() !void {
        var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
        defer arena.deinit();

        const allocator = arena.allocator();

        const manifest_platform = image.Platform{
            .architecture = image.Arch.PowerPC64,
            .os = image.OS.Linux,
        };

        const index_manifest = image.Descriptor{
            .mediaType = image.MediaType.ImageManifest,
            .size = 32654,
            .platform = manifest_platform,
            .digest = try image.Digest.initFromString(allocator, "sha256:9834876dcfb05cb167a5c24953eba58c4ac89b1adf57f28f2f9d09af107ee8f0"),
        };

        var manifests = std.ArrayList(image.Descriptor).init(allocator);

        try manifests.append(index_manifest);

        const image_manifests: []image.Descriptor = try manifests.toOwnedSlice();

        const image_index = image.Index{
            .mediaType = image.MediaType.ImageIndex,
            .manifests = image_manifests,
        };

        const image_index_content = try image_index.toStringPretty(allocator);

        const stdout_file = std.io.getStdOut().writer();
        var bw = std.io.bufferedWriter(stdout_file);
        const stdout = bw.writer();

        try stdout.print("{s}\n", .{image_index_content});

        try bw.flush();
    }

Image manifest
------------------------

.. code-block:: zig

    const std = @import("std");
    const ocispec = @import("ocispec");
    const image = ocispec.image;

    pub fn main() !void {
        var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
        defer arena.deinit();

        const allocator = arena.allocator();

        const media_manifest = image.MediaType.ImageManifest;
        const media_config = image.MediaType.ImageConfig;
        const media_layer = image.MediaType.ImageLayerGzip;

        var mlayers = std.ArrayList(image.Descriptor).init(allocator);
        try mlayers.append(image.Descriptor{
            .mediaType = media_layer,
            .digest = try image.Digest.initFromString(
                allocator,
                "sha256:9834876dcfb05cb167a5c24953eba58c4ac89b1adf57f28f2f9d09af107ee8f",
            ),
            .size = 32654,
        });

        const manifest_layers: []image.Descriptor = try mlayers.toOwnedSlice();

        const manifest = image.Manifest{
            .mediaType = media_manifest,
            .config = image.Descriptor{
                .mediaType = media_config,
                .digest = try image.Digest.initFromString(
                    allocator,
                    "sha256:b5b2b2c507a0944348e0303114d8d93aaaa081732b86451d9bce1f432a537bc7",
                ),
                .size = 7023,
            },
            .layers = manifest_layers,
        };

        const manifest_content = try manifest.toStringPretty(allocator);

        const stdout_file = std.io.getStdOut().writer();
        var bw = std.io.bufferedWriter(stdout_file);
        const stdout = bw.writer();

        try stdout.print("{s}\n", .{manifest_content});

        try bw.flush();
    }



OCI layout
------------------------

.. code-block:: zig

    const std = @import("std");
    const ocispec = @import("ocispec");
    const image = ocispec.image;

    pub fn main() !void {
        var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
        defer arena.deinit();

        const allocator = arena.allocator();

        const oci_layout = image.OciLayout{};

        const oci_layout_content = try oci_layout.toStringPretty(allocator);

        const stdout_file = std.io.getStdOut().writer();
        var bw = std.io.bufferedWriter(stdout_file);
        const stdout = bw.writer();

        try stdout.print("{s}\n", .{oci_layout_content});

        try bw.flush();
    }



Artifact manifest
------------------------

.. code-block:: zig

    const std = @import("std");
    const ocispec = @import("ocispec");
    const image = ocispec.image;

    pub fn main() !void {
        var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
        defer arena.deinit();

        const allocator = arena.allocator();

        const file_path = "./tests/fixtures/artifact_manifest.json";
        const artifact_manifest = try image.ArtifactManifest.initFromFile(allocator, file_path);

        const config_content = try artifact_manifest.toStringPretty(allocator);

        const stdout_file = std.io.getStdOut().writer();
        var bw = std.io.bufferedWriter(stdout_file);
        const stdout = bw.writer();

        try stdout.print("{s}\n", .{config_content});

        try bw.flush();
    }
