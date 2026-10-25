const std = @import("std");
const fizzbuzz = @import("fizzbuzz");

const app_name = "fizzbuzz_take_02";
const app_version = "0.0.1";
const default_n: usize = 15;

pub fn main(init: std.process.Init) !void {
    std.log.info("--- Start app {s} v. {s}.", .{ app_name, app_version });

    const io = init.io;
    const arena = init.arena.allocator();
    const args = try init.minimal.args.toSlice(arena);

    var n: usize = default_n;

    // Manage input arguments, accepting zero or one positional argument
    if (args.len > 2) {
        std.log.err("Usage: {s} [n]", .{args[0]});
        return error.InvalidArguments;
    }

    if (args.len == 2) {
        n = std.fmt.parseInt(usize, args[1], 10) catch {
            std.log.err("Invalid non-negative integer: '{s}'", .{args[1]});
            return error.InvalidNumber;
        };
    }

    // Stream each result directly to stdout
    var writer_buf: [0x100]u8 = undefined;
    var writer = std.Io.File.stdout().writer(io, &writer_buf);
    const stdout = &writer.interface;

    // Print fizzbuzz representations for the first n numbers
    var string_buf: [20]u8 = undefined;
    var fb_string: []const u8 = undefined;

    for (1..n + 1) |i| {
        fb_string = try fizzbuzz.fb(i, &string_buf);
        try stdout.print("{d:2} -> {s}\n", .{ i, fb_string });
    }

    try stdout.flush();

    std.log.info("--- End app {s} v. {s}.", .{ app_name, app_version });
}
