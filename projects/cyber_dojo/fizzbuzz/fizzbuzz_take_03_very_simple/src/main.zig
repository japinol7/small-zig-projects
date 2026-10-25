const std = @import("std");
const fizzbuzz = @import("fizzbuzz");

const app_name = "fizzbuzz_take_03";
const app_version = "0.0.1";

pub fn main() !void {
    std.log.info("--- Start app {s} v. {s}.", .{ app_name, app_version });

    const n: usize = 15;

    // Print fizzbuzz representations for the first n numbers
    var string_buf: [20]u8 = undefined;
    var fb_string: []const u8 = undefined;

    for (1..n + 1) |i| {
        fb_string = try fizzbuzz.fb(i, &string_buf);
        std.log.info("{d:2} -> {s}", .{ i, fb_string });
    }

    std.log.info("--- End app {s} v. {s}.", .{ app_name, app_version });
}
