# FizzBuzz in Zig

The project keeps the reusable FizzBuzz logic separate from the command-line interface, and uses table-driven tests
inspired by Go's testing style and Python's `pytest.mark.parametrize`.

## Features

- **Lazy iteration** — generate each FizzBuzz value only when requested.
- **No per-number heap allocation** — numeric values are formatted into a caller-provided buffer.
- **Streaming output** — the CLI writes each result directly to standard output instead of building the entire sequence
  in memory.
- **Table-driven tests** — named cases make it easy to add examples and edge cases.
- **Argument validation** — accepts an optional non-negative integer limit.

## Project structure

```text
.
├── build.zig
├── build.zig.zon          # Package manifest (kept in the project)
├── src
│   ├── fizzbuzz.zig       # Core FizzBuzz function and iterator
│   └── main.zig           # CLI argument parsing and stdout output
└── tests
    └── main_test.zig      # Unit tests for the core module
```

## Requirements

- [Zig](https://ziglang.org/) **0.17.0**

## Build

Compile the executable:

```sh
zig build
```

The executable is installed at:

```text
zig-out/bin/fizzbuzz
```

## Run

Run with the default limit of `15`:

```sh
zig build run
```

Run up to a custom limit:

```sh
zig build run -- 20
```

Or invoke the built executable directly:

```sh
./zig-out/bin/fizzbuzz 100
```

The program prints one result per line. Example:

```text
info: --- Start app fizzbuzz_take_01 v. 0.0.1.
 1 -> 1
 2 -> 2
 3 -> Fizz
 4 -> 4
 5 -> Buzz
 6 -> Fizz
 7 -> 7
 8 -> 8
 9 -> Fizz
10 -> Buzz
11 -> 11
12 -> Fizz
13 -> 13
14 -> 14
15 -> FizzBuzz
info: --- End app fizzbuzz_take_01 v. 0.0.1.
```

## Run the tests

Run all tests through the build system:

```sh
zig build test
```

The test suite includes:

- Named, table-driven cases for individual values such as `3 → Fizz`, `5 → Buzz`, and `15 → FizzBuzz`.
- Range cases for limits `0`, `1`, `2`, and `15`.
- An exact-output comparison for the sequence through `100`.

The tests use a small helper to collect iterator output for comparison. The production CLI does not use that helper; it
streams results directly to standard output.

## Design notes

### `src/fizzbuzz.zig`

This module contains the reusable logic:

- `fb(n, buf)` formats one value.
- `FbRange` is a stateful iterator with a `next()` method.
- `fb_range(n)` creates an iterator for values from `1` through `n`.

The iterator is lazy: it computes each value only when `next()` is called. The caller provides a buffer for numeric
formatting. Because that buffer is reused, consume each returned slice before requesting the next value.

### `src/main.zig`

The CLI is responsible for:

1. Reading and validating the optional command-line argument.
2. Selecting the default limit when no argument is supplied.
3. Iterating through the results.
4. Streaming each line to standard output.

Keeping the CLI separate from the core module makes the FizzBuzz logic straightforward to reuse and test.
