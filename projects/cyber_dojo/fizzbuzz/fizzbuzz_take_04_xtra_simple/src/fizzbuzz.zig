const std = @import("std");

const app_name = "fizzbuzz_take_04";
const app_version = "0.0.1";

/// Returns the FizzBuzz representation of `n`.
/// Numeric results are formatted into the caller-provided buffer.
/// The returned slice is only valid until that buffer is reused or goes out
/// of scope. Fizz/Buzz results are string literals.
pub fn fb(n: usize, buf: []u8) ![]const u8 {
    if (n % 15 == 0) return "FizzBuzz";
    if (n % 3 == 0) return "Fizz";
    if (n % 5 == 0) return "Buzz";

    return std.fmt.bufPrint(buf, "{d}", .{n});
}

pub fn main(init: std.process.Init) !void {
    std.log.info("--- Start app {s} v. {s}.", .{ app_name, app_version });

    const io = init.io;
    const n: usize = 15;

    // Stream each result directly to stdout
    var writer_buf: [0x100]u8 = undefined;
    var writer = std.Io.File.stdout().writer(io, &writer_buf);
    const stdout = &writer.interface;

    // Print fizzbuzz representations for the first n numbers
    var string_buf: [20]u8 = undefined;
    var fb_string: []const u8 = undefined;

    for (1..n + 1) |i| {
        fb_string = try fb(i, &string_buf);
        try stdout.print("{d:2} -> {s}\n", .{ i, fb_string });
    }

    try stdout.flush();

    std.log.info("--- End app {s} v. {s}.", .{ app_name, app_version });
}

// ----------------------
// Tests
// ----------------------

const FbCase = struct {
    name: []const u8,
    input: usize,
    expected: []const u8,
};

test "fb: table-driven cases" {
    const cases = [_]FbCase{
        .{ .name = "num 1", .input = 1, .expected = "1" },
        .{ .name = "num 2", .input = 2, .expected = "2" },
        .{ .name = "num 3", .input = 3, .expected = "Fizz" },
        .{ .name = "num 4", .input = 4, .expected = "4" },
        .{ .name = "num 5", .input = 5, .expected = "Buzz" },
        .{ .name = "num 6", .input = 6, .expected = "Fizz" },
        .{ .name = "num 10", .input = 10, .expected = "Buzz" },
        .{ .name = "num 13", .input = 13, .expected = "13" },
        .{ .name = "num 15", .input = 15, .expected = "FizzBuzz" },
        .{ .name = "num 21", .input = 21, .expected = "Fizz" },
        .{ .name = "num 22", .input = 22, .expected = "22" },
        .{ .name = "num 45", .input = 45, .expected = "FizzBuzz" },
        .{ .name = "num 52", .input = 52, .expected = "52" },
    };

    var buf: [20]u8 = undefined;
    for (cases) |tc| {
        const actual = try fb(tc.input, &buf);
        std.testing.expectEqualStrings(tc.expected, actual) catch |err| {
            std.debug.print(
                "fb case failed: {s} (input={d})\n",
                .{ tc.name, tc.input },
            );
            return err;
        };
    }
}
