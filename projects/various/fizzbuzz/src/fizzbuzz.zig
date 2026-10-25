const std = @import("std");

/// Returns the FizzBuzz representation of `n`.
pub fn fb(n: usize, buf: []u8) ![]const u8 {
    if (n % 15 == 0) return "FizzBuzz";
    if (n % 3 == 0) return "Fizz";
    if (n % 5 == 0) return "Buzz";

    return std.fmt.bufPrint(buf, "{d}", .{n});
}

pub fn main(init: std.process.Init) !void {
    const io = init.io;
    const n: usize = 15;

    // Get stdout writer
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
}
