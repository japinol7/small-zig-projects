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

/// Lazy iterator over FizzBuzz values from 1 through `end`.
pub const FbRange = struct {
    current: usize = 1,
    end: usize,
    done: bool = false,

    pub fn next(self: *FbRange, buf: []u8) !?[]const u8 {
        if (self.done or self.current > self.end) return null;

        const n = self.current;

        // Avoid incrementing maxInt(usize), which would overflow
        if (n == self.end) {
            self.done = true;
        } else {
            self.current += 1;
        }

        return try fb(n, buf);
    }
};

pub fn fb_range(n: usize) FbRange {
    return .{ .end = n };
}
