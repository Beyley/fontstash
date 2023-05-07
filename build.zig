const std = @import("std");

pub fn buildFontstash(b: *std.Build, target: std.zig.CrossTarget, optimize: std.builtin.OptimizeMode, shared: bool) *std.Build.CompileStep {
    var library_options = .{
        .name = "fontstash",
        .target = target,
        .optimize = optimize,
    };

    var fontstash = if (shared) b.addSharedLibrary(library_options) else b.addStaticLibrary(library_options);

    fontstash.linkLibC();

    fontstash.addCSourceFile(root_path ++ "src/fontstash.c", &.{});

    return fontstash;
}

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    b.installArtifact(buildFontstash(b, target, optimize, false));
    b.installArtifact(buildFontstash(b, target, optimize, true));
}

fn root() []const u8 {
    return std.fs.path.dirname(@src().file) orelse ".";
}

const root_path = root() ++ "/";
