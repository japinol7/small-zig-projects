const std = @import("std");

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
