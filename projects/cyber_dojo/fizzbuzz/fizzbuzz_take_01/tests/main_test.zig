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

/// Collects the iterator output for assertions. Production CLI output streams
/// values directly and does not need this helper.
fn collectRange(allocator: std.mem.Allocator, n: usize) ![]u8 {
    var output: std.ArrayList(u8) = .empty;
    defer output.deinit(allocator);

    var iter = fizzbuzz.fb_range(n);
    var buf: [20]u8 = undefined;
    var first = true;

    while (try iter.next(&buf)) |value| {
        if (!first) try output.append(allocator, '\n');
        try output.appendSlice(allocator, value);
        first = false;
    }

    return try output.toOwnedSlice(allocator);
}

const RangeCase = struct {
    name: []const u8,
    input: usize,
    expected: []const u8,
};

test "fb_range: table-driven cases" {
    const cases = [_]RangeCase{
        .{ .name = "range 0", .input = 0, .expected = "" },
        .{ .name = "range 1", .input = 1, .expected = "1" },
        .{ .name = "range 2", .input = 2, .expected = "1\n2" },
        .{
            .name = "range 15",
            .input = 15,
            .expected = "1\n2\nFizz\n4\nBuzz\nFizz\n7\n8\nFizz\nBuzz\n11\nFizz\n13\n14\nFizzBuzz",
        },
    };

    for (cases) |tc| {
        const actual = try collectRange(std.testing.allocator, tc.input);
        defer std.testing.allocator.free(actual);

        std.testing.expectEqualStrings(tc.expected, actual) catch |err| {
            std.debug.print(
                "fb_range case failed: {s} (input={d})\n",
                .{ tc.name, tc.input },
            );
            return err;
        };
    }
}
