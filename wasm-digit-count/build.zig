// File: wasm-digit-count/build.zig
const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const lib = b.addSharedLibrary(.{
        .name = "digit-count",
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target,
        .optimize = optimize,
    });

    // These options are still valid
    lib.rdynamic = true;
    lib.linkage = .dynamic;

    // Remove the problematic line:
    // lib.entry = .disabled;

    b.installArtifact(lib);
}