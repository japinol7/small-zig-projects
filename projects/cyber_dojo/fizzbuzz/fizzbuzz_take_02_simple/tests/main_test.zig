const std = @import("std");
const fizzbuzz = @import("fizzbuzz");

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
        const actual = try fizzbuzz.fb(tc.input, &buf);
        std.testing.expectEqualStrings(tc.expected, actual) catch |err| {
            std.debug.print(
                "fb case failed: {s} (input={d})\n",
                .{ tc.name, tc.input },
            );
            return err;
        };
    }
}
