// File: wasm-digit-count/src/main.zig
const std = @import("std");

export fn countDigits(a: i32, b: i32) i32 {
    return countDigitsOfNumber(a) + countDigitsOfNumber(b);
}

fn countDigitsOfNumber(num: i32) i32 {
    var n = if (num < 0) -num else num;

    if (n == 0) {
        return 1;
    }

    var count: i32 = 0;
    while (n > 0) {
        count += 1;
        n = @divTrunc(n, 10);
    }

    return count;
}