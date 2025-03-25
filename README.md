![License](https://img.shields.io/badge/license-MIT-blue)
![Build](https://github.com/navidys/oci-spec-zig/workflows/build/badge.svg)
[![codecov](https://codecov.io/gh/navidys/oci-spec-zig/branch/main/graph/badge.svg)](https://codecov.io/gh/navidys/oci-spec-zig)
![GitHub release (latest SemVer)](https://img.shields.io/github/v/release/navidys/oci-spec-zig)

# oci-spec-zig
OCI Runtime, Image and Distribution Spec in Zig.

This library provides a convenient way to interact with the specifications defined by the [Open Container Initiative (OCI)](https://opencontainers.org).

- [Image Format Specification](https://github.com/opencontainers/image-spec/blob/main/spec.md)
- [Runtime Specification](https://github.com/opencontainers/runtime-spec/blob/master/spec.md)
- [Distribution Specification](https://github.com/opencontainers/distribution-spec/blob/main/spec.md)

## Requirements

Zig version >= 0.14.0

## Build

```
$ make build
```

## Tests

To run unit-tests:

```shell
$ make test
```

To generate coverage first its requires to install `kcov` utility.

```shell
$ make .install.kcov
$ make coverage
```

## Example

```shell
const std = @import("std");
const ocispec = @import("ocispec");
const image = ocispec.image;

pub fn main() !void {
    const media_manifest = image.MediaType.ImageManifest;
    const media_config = image.MediaType.ImageConfig;
    const media_layer = image.MediaType.ImageLayerGzip;

    var mlayers = std.ArrayList(image.Descriptor).init(std.heap.page_allocator);
    try mlayers.append(image.Descriptor{
        .mediaType = media_layer,
        .digest = try image.Digest.initFromString("sha256:9834876dcfb05cb167a5c24953eba58c4ac89b1adf57f28f2f9d09af107ee8f"),
        .size = 32654,
    });

    const manifest_layers: []image.Descriptor = try mlayers.toOwnedSlice();

    const manifest = image.Manifest{
        .mediaType = media_manifest,
        .config = image.Descriptor{
            .mediaType = media_config,
            .digest = try image.Digest.initFromString("sha256:b5b2b2c507a0944348e0303114d8d93aaaa081732b86451d9bce1f432a537bc7"),
            .size = 7023,
        },
        .layers = manifest_layers,
    };

    const manifest_content = try manifest.toStringPretty();

    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    const stdout = bw.writer();

    try stdout.print("{s}\n", .{manifest_content});

    try bw.flush();
}
```

## License
Licensed under the [MIT License](https://github.com/navidys/oci-spec-zig/blob/main/LICENSE).
