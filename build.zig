// SPDX-License-Identifier: PMPL-2.0-or-later
const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const core = b.addModule("authority_watch", .{
        .root_source_file = b.path("zig/src/core.zig"),
        .target = target,
        .optimize = optimize,
    });

    const exe = b.addExecutable(.{
        .name = "authority-watch",
        .root_module = b.createModule(.{
            .root_source_file = b.path("zig/src/main.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{.{ .name = "authority_watch", .module = core }},
        }),
    });
    b.installArtifact(exe);

    const run = b.addRunArtifact(exe);
    run.step.dependOn(b.getInstallStep());
    if (b.args) |args| run.addArgs(args);
    const run_step = b.step("run", "Run the offline Authority Watch operator shell");
    run_step.dependOn(&run.step);

    const unit_tests = b.addTest(.{ .root_module = core });
    const run_unit = b.addRunArtifact(unit_tests);
    const test_step = b.step("test", "Run core safety and determinism tests");
    test_step.dependOn(&run_unit.step);
}
