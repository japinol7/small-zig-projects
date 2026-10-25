const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // Core FizzBuzz logic, shared by the CLI and tests
    const fizzbuzz_module = b.createModule(.{
        .root_source_file = b.path("src/fizzbuzz.zig"),
        .target = target,
        .optimize = optimize,
    });

    // CLI executable
    const app_module = b.createModule(.{
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{
            .{
                .name = "fizzbuzz",
                .module = fizzbuzz_module,
            },
        },
    });

    const exe = b.addExecutable(.{
        .name = "fizzbuzz",
        .root_module = app_module,
    });
    b.installArtifact(exe);

    // `zig build run -- 20`
    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());
    run_cmd.addPassthruArgs();

    const run_step = b.step("run", "Run FizzBuzz");
    run_step.dependOn(&run_cmd.step);

    // Tests import the core module directly, not main.zig
    const test_module = b.createModule(.{
        .root_source_file = b.path("tests/main_test.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{
            .{
                .name = "fizzbuzz",
                .module = fizzbuzz_module,
            },
        },
    });

    const tests = b.addTest(.{
        .root_module = test_module,
    });
    const run_tests = b.addRunArtifact(tests);

    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_tests.step);
}
