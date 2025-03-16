const std = @import("std");

/// Media types used by OCI image format spec. Values MUST comply with RFC 6838,
/// including the naming requirements in its section 4.2.
pub const MediaType = enum {
    /// MediaType Descriptor specifies the media type for a content descriptor.
    Descriptor,
    /// MediaType LayoutHeader specifies the media type for the oci-layout.
    LayoutHeader,
    /// MediaType ImageManifest specifies the media type for an image manifest.
    ImageManifest,
    /// MediaType ImageIndex specifies the media type for an image index.
    ImageIndex,
    /// MediaType ImageLayer is the media type used for layers referenced by the
    /// manifest.
    ImageLayer,
    /// MediaType ImageLayerGzip is the media type used for gzipped layers
    /// referenced by the manifest.
    ImageLayerGzip,
    /// MediaType ImageLayerZstd is the media type used for zstd compressed
    /// layers referenced by the manifest.
    ImageLayerZstd,
    /// MediaType ImageLayerNonDistributable is the media type for layers
    /// referenced by the manifest but with distribution restrictions.
    ImageLayerNonDistributable,
    /// MediaType ImageLayerNonDistributableGzip is the media type for
    /// gzipped layers referenced by the manifest but with distribution
    /// restrictions.
    ImageLayerNonDistributableGzip,
    /// MediaType ImageLayerNonDistributableZstd is the media type for zstd
    /// compressed layers referenced by the manifest but with distribution
    /// restrictions.
    ImageLayerNonDistributableZstd,
    /// MediaType ImageConfig specifies the media type for the image
    /// configuration.
    ImageConfig,
    /// MediaType ArtifactManifest specifies the media type used for content addressable
    /// artifacts to store them along side container images in a registry.
    ArtifactManifest,
    /// MediaType EmptyJSON specifies a descriptor that has no content for the implementation. The
    /// blob payload is the most minimal content that is still a valid JSON object: {} (size of 2).
    /// The blob digest of {} is
    /// sha256:44136fa355b3678a1146ad16f7e8649e94fb4fc21fe77e8310c060f61caaff8a.
    EmptyJSON,
    /// MediaType not specified by OCI image format.
    Other,

    pub fn jsonStringify(self: *const MediaType, jws: anytype) !void {
        switch (self.*) {
            MediaType.Descriptor => try jws.print("\"application/vnd.oci.descriptor\"", .{}),
            MediaType.LayoutHeader => try jws.print("\"application/vnd.oci.layout.header.v1+json\"", .{}),
            MediaType.ImageManifest => try jws.print("\"application/vnd.oci.image.manifest.v1+json\"", .{}),
            MediaType.ImageIndex => try jws.print("\"application/vnd.oci.image.index.v1+json\"", .{}),
            MediaType.ImageLayer => try jws.print("\"application/vnd.oci.image.layer.v1.tar\"", .{}),
            MediaType.ImageLayerGzip => try jws.print("\"application/vnd.oci.image.layer.v1.tar+gzip\"", .{}),
            MediaType.ImageLayerZstd => try jws.print("\"application/vnd.oci.image.layer.v1.tar+zstd\"", .{}),
            MediaType.ImageLayerNonDistributable => try jws.print("\"application/vnd.oci.image.layer.nondistributable.v1.tar\"", .{}),
            MediaType.ImageLayerNonDistributableGzip => try jws.print("\"application/vnd.oci.image.layer.nondistributable.v1.tar+gzip\"", .{}),
            MediaType.ImageLayerNonDistributableZstd => try jws.print("\"application/vnd.oci.image.layer.nondistributable.v1.tar+zstd\"", .{}),
            MediaType.ImageConfig => try jws.print("\"application/vnd.oci.image.config.v1+json\"", .{}),
            MediaType.ArtifactManifest => try jws.print("\"application/vnd.oci.artifact.manifest.v1+json\"", .{}),
            MediaType.EmptyJSON => try jws.print("\"application/vnd.oci.empty.v1+json\"", .{}),
            MediaType.Other => try jws.print("\"other\"", .{}),
        }
    }

    pub fn jsonParse(allocator: std.mem.Allocator, source: anytype, _: std.json.ParseOptions) !MediaType {
        switch (try source.nextAlloc(allocator, .alloc_if_needed)) {
            .string, .allocated_string => |mtype| {
                if (std.mem.eql(u8, mtype, "application/vnd.oci.descriptor") == true) {
                    return MediaType.Descriptor;
                }

                if (std.mem.eql(u8, mtype, "application/vnd.oci.layout.header.v1+json") == true) {
                    return MediaType.LayoutHeader;
                }

                if (std.mem.eql(u8, mtype, "application/vnd.oci.image.manifest.v1+json") == true) {
                    return MediaType.ImageManifest;
                }

                if (std.mem.eql(u8, mtype, "application/vnd.oci.image.index.v1+json") == true) {
                    return MediaType.ImageIndex;
                }

                if (std.mem.eql(u8, mtype, "application/vnd.oci.image.layer.v1.tar") == true) {
                    return MediaType.ImageLayer;
                }

                if (std.mem.eql(u8, mtype, "application/vnd.oci.image.layer.v1.tar+gzip") == true) {
                    return MediaType.ImageLayerGzip;
                }

                if (std.mem.eql(u8, mtype, "application/vnd.oci.image.layer.v1.tar+zstd") == true) {
                    return MediaType.ImageLayerZstd;
                }

                if (std.mem.eql(u8, mtype, "application/vnd.oci.image.layer.nondistributable.v1.tar") == true) {
                    return MediaType.ImageLayerNonDistributable;
                }

                if (std.mem.eql(u8, mtype, "application/vnd.oci.image.layer.nondistributable.v1.tar+gzip") == true) {
                    return MediaType.ImageLayerNonDistributableGzip;
                }

                if (std.mem.eql(u8, mtype, "application/vnd.oci.image.layer.nondistributable.v1.tar+zstd") == true) {
                    return MediaType.ImageLayerNonDistributableZstd;
                }

                if (std.mem.eql(u8, mtype, "application/vnd.oci.image.config.v1+json") == true) {
                    return MediaType.ImageConfig;
                }

                if (std.mem.eql(u8, mtype, "application/vnd.oci.artifact.manifest.v1+json") == true) {
                    return MediaType.ArtifactManifest;
                }

                if (std.mem.eql(u8, mtype, "application/vnd.oci.empty.v1+json") == true) {
                    return MediaType.EmptyJSON;
                }
            },
            else => return MediaType.Other,
        }

        return MediaType.Other;
    }
};

/// Name of the target operating system.
pub const OS = enum {
    AIX,
    Android,
    Darwin,
    DragonFlyBSD,
    FreeBSD,
    Hurd,
    Illumos,
    IOS,
    Js,
    Linux,
    Nacl,
    NetBSD,
    OpenBSD,
    Plan9,
    Solaris,
    Windows,
    ZOS,
    Other,

    pub fn jsonParse(allocator: std.mem.Allocator, source: anytype, _: std.json.ParseOptions) !OS {
        switch (try source.nextAlloc(allocator, .alloc_if_needed)) {
            .string, .allocated_string => |ostype| {
                if (std.mem.eql(u8, ostype, "aix") == true) {
                    return OS.AIX;
                }

                if (std.mem.eql(u8, ostype, "android") == true) {
                    return OS.Android;
                }

                if (std.mem.eql(u8, ostype, "darwin") == true) {
                    return OS.Darwin;
                }

                if (std.mem.eql(u8, ostype, "dragonfly") == true) {
                    return OS.DragonFlyBSD;
                }

                if (std.mem.eql(u8, ostype, "freebsd") == true) {
                    return OS.FreeBSD;
                }

                if (std.mem.eql(u8, ostype, "hurd") == true) {
                    return OS.Hurd;
                }

                if (std.mem.eql(u8, ostype, "illumos") == true) {
                    return OS.Illumos;
                }

                if (std.mem.eql(u8, ostype, "ios") == true) {
                    return OS.IOS;
                }

                if (std.mem.eql(u8, ostype, "js") == true) {
                    return OS.Js;
                }

                if (std.mem.eql(u8, ostype, "linux") == true) {
                    return OS.Linux;
                }

                if (std.mem.eql(u8, ostype, "nacl") == true) {
                    return OS.Nacl;
                }

                if (std.mem.eql(u8, ostype, "netbsd") == true) {
                    return OS.NetBSD;
                }

                if (std.mem.eql(u8, ostype, "openbsd") == true) {
                    return OS.OpenBSD;
                }

                if (std.mem.eql(u8, ostype, "plan9") == true) {
                    return OS.Plan9;
                }

                if (std.mem.eql(u8, ostype, "windows") == true) {
                    return OS.Windows;
                }

                if (std.mem.eql(u8, ostype, "zos") == true) {
                    return OS.ZOS;
                }
            },
            else => return OS.Other,
        }

        return OS.Other;
    }

    pub fn jsonStringify(self: *const OS, jws: anytype) !void {
        switch (self.*) {
            OS.AIX => try jws.print("\"aix\"", .{}),
            OS.Android => try jws.print("\"android\"", .{}),
            OS.Darwin => try jws.print("\"darwin\"", .{}),
            OS.DragonFlyBSD => try jws.print("\"dragonfly\"", .{}),
            OS.FreeBSD => try jws.print("\"freebsd\"", .{}),
            OS.Hurd => try jws.print("\"hurd\"", .{}),
            OS.Illumos => try jws.print("\"illumos\"", .{}),
            OS.IOS => try jws.print("\"ios\"", .{}),
            OS.Js => try jws.print("\"js\"", .{}),
            OS.Linux => try jws.print("\"linux\"", .{}),
            OS.Nacl => try jws.print("\"nacl\"", .{}),
            OS.NetBSD => try jws.print("\"netbsd\"", .{}),
            OS.OpenBSD => try jws.print("\"openbsd\"", .{}),
            OS.Plan9 => try jws.print("\"plan9\"", .{}),
            OS.Solaris => try jws.print("\"solaris\"", .{}),
            OS.Windows => try jws.print("\"windows\"", .{}),
            OS.ZOS => try jws.print("\"zos\"", .{}),
            OS.Other => try jws.print("\"other\"", .{}),
        }
    }
};

/// Name of the CPU target architecture.
pub const Arch = enum {
    /// 32 bit x86, little-endian
    I386,
    /// 64 bit x86, little-endian
    Amd64,
    /// 64 bit x86 with 32 bit pointers, little-endian
    Amd64p32,
    /// 32 bit ARM, little-endian
    ARM,
    /// 32 bit ARM, big-endian
    ARMbe,
    /// 64 bit ARM, little-endian
    ARM64,
    /// 64 bit ARM, big-endian
    ARM64be,
    /// 64 bit Loongson RISC CPU, little-endian
    LoongArch64,
    /// 32 bit Mips, big-endian
    Mips,
    /// 32 bit Mips, little-endian
    Mipsle,
    /// 64 bit Mips, big-endian
    Mips64,
    /// 64 bit Mips, little-endian
    Mips64le,
    /// 64 bit Mips with 32 bit pointers, big-endian
    Mips64p32,
    /// 64 bit Mips with 32 bit pointers, little-endian
    Mips64p32le,
    /// 32 bit PowerPC, big endian
    PowerPC,
    /// 64 bit PowerPC, big-endian
    PowerPC64,
    /// 64 bit PowerPC, little-endian
    PowerPC64le,
    /// 32 bit RISC-V, little-endian
    RISCV,
    /// 64 bit RISC-V, little-endian
    RISCV64,
    /// 32 bit IBM System/390, big-endian
    S390,
    /// 64 bit IBM System/390, big-endian
    S390x,
    /// 32 bit SPARC, big-endian
    SPARC,
    /// 64 bit SPARC, bi-endian
    SPARC64,
    /// 32 bit Web Assembly
    Wasm,
    /// Architecture not specified by OCI image format
    Other,

    pub fn jsonParse(allocator: std.mem.Allocator, source: anytype, _: std.json.ParseOptions) !Arch {
        switch (try source.nextAlloc(allocator, .alloc_if_needed)) {
            .string, .allocated_string => |archt| {
                if (std.mem.eql(u8, archt, "386") == true) {
                    return Arch.I386;
                }

                if (std.mem.eql(u8, archt, "amd64") == true) {
                    return Arch.Amd64;
                }

                if (std.mem.eql(u8, archt, "amd64p32") == true) {
                    return Arch.Amd64p32;
                }

                if (std.mem.eql(u8, archt, "arm") == true) {
                    return Arch.ARM;
                }

                if (std.mem.eql(u8, archt, "armbe") == true) {
                    return Arch.ARMbe;
                }

                if (std.mem.eql(u8, archt, "arm64") == true) {
                    return Arch.ARM64;
                }

                if (std.mem.eql(u8, archt, "arm64be") == true) {
                    return Arch.ARM64be;
                }

                if (std.mem.eql(u8, archt, "loong64") == true) {
                    return Arch.LoongArch64;
                }

                if (std.mem.eql(u8, archt, "mips") == true) {
                    return Arch.Mips;
                }

                if (std.mem.eql(u8, archt, "mipsle") == true) {
                    return Arch.Mipsle;
                }

                if (std.mem.eql(u8, archt, "mips64") == true) {
                    return Arch.Mips64;
                }

                if (std.mem.eql(u8, archt, "mips64le") == true) {
                    return Arch.Mips64le;
                }

                if (std.mem.eql(u8, archt, "mips64p32") == true) {
                    return Arch.Mips64p32;
                }

                if (std.mem.eql(u8, archt, "mips64p32le") == true) {
                    return Arch.Mips64p32le;
                }

                if (std.mem.eql(u8, archt, "ppc") == true) {
                    return Arch.PowerPC;
                }

                if (std.mem.eql(u8, archt, "ppc64") == true) {
                    return Arch.PowerPC64;
                }

                if (std.mem.eql(u8, archt, "ppc64le") == true) {
                    return Arch.PowerPC64le;
                }

                if (std.mem.eql(u8, archt, "riscv") == true) {
                    return Arch.RISCV;
                }

                if (std.mem.eql(u8, archt, "riscv64") == true) {
                    return Arch.RISCV64;
                }

                if (std.mem.eql(u8, archt, "s390") == true) {
                    return Arch.S390;
                }

                if (std.mem.eql(u8, archt, "s390x") == true) {
                    return Arch.S390x;
                }

                if (std.mem.eql(u8, archt, "sparc") == true) {
                    return Arch.SPARC;
                }

                if (std.mem.eql(u8, archt, "sparc64") == true) {
                    return Arch.SPARC64;
                }

                if (std.mem.eql(u8, archt, "wasm") == true) {
                    return Arch.Wasm;
                }
            },
            else => return Arch.Other,
        }

        return Arch.Other;
    }

    pub fn jsonStringify(self: *const Arch, jws: anytype) !void {
        switch (self.*) {
            Arch.I386 => try jws.print("\"386\"", .{}),
            Arch.Amd64 => try jws.print("\"amd64\"", .{}),
            Arch.Amd64p32 => try jws.print("\"amd64p32\"", .{}),
            Arch.ARM => try jws.print("\"arm\"", .{}),
            Arch.ARMbe => try jws.print("\"armbe\"", .{}),
            Arch.ARM64 => try jws.print("\"arm64\"", .{}),
            Arch.ARM64be => try jws.print("\"arm64be\"", .{}),
            Arch.LoongArch64 => try jws.print("\"loong64\"", .{}),
            Arch.Mips => try jws.print("\"mips\"", .{}),
            Arch.Mipsle => try jws.print("\"mipsle\"", .{}),
            Arch.Mips64 => try jws.print("\"mips64\"", .{}),
            Arch.Mips64le => try jws.print("\"mips64le\"", .{}),
            Arch.Mips64p32 => try jws.print("\"mips64p32\"", .{}),
            Arch.Mips64p32le => try jws.print("\"mips64p32le\"", .{}),
            Arch.PowerPC => try jws.print("\"ppc\"", .{}),
            Arch.PowerPC64 => try jws.print("\"ppc64\"", .{}),
            Arch.PowerPC64le => try jws.print("\"ppc64le\"", .{}),
            Arch.RISCV => try jws.print("\"riscv\"", .{}),
            Arch.RISCV64 => try jws.print("\"riscv64\"", .{}),
            Arch.S390 => try jws.print("\"s390\"", .{}),
            Arch.S390x => try jws.print("\"s390x\"", .{}),
            Arch.SPARC => try jws.print("\"sparc\"", .{}),
            Arch.SPARC64 => try jws.print("\"sparc64\"", .{}),
            Arch.Wasm => try jws.print("\"wasm\"", .{}),
            Arch.Other => try jws.print("\"other\"", .{}),
        }
    }
};
