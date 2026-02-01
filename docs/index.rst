oci-spec-zig documentation
====================================

**oci-spec-zig**  is OCI Runtime, Image and Distribution Spec library written in Zig.

This library provides a convenient way to interact with the specifications defined by the `Open Container Initiative (OCI) https://opencontainers.org`.

- `Image Format Specification https://github.com/opencontainers/image-spec/blob/main/spec.md`
- `Runtime Specification https://github.com/opencontainers/runtime-spec/blob/master/spec.md`
- `Distribution Specification https://github.com/opencontainers/distribution-spec/blob/main/spec.md`


Requirements
--------------
Zig version >= 0.14.1


Installation
--------------

Fetch latest tagged release or lated build of oci-spec-zs master branch.

.. code-block:: bash

    # Version of oci-spec-zig that works with a tagged release of Zig
    # Replace `<REPLACE ME>` with the version of oci-spec-zig that you want to use
    # See: https://github.com/navidys/oci-spec-zig/releases
    zig fetch --save https://github.com/navidys/oci-spec-zig/archive/refs/tags/<REPLACE ME>.tar.gz


    # oci-spec-zig latest build (master branch)
    zig fetch --save git+https://github.com/navidys/oci-spec-zig


Then add the following toe build.zig:

.. code-block:: zig

    const ocispec = b.dependency("ocispec", .{});
    exe.root_module.addImport("ocispec", ocispec.module("ocispec"));
