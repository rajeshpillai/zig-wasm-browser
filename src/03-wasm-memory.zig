// 1. We create a global variable. In Wasm, this lives in "linear memory".
var counter: u8 = 0;

// 2. We export a function that returns the *address* (index) of this variable.
export fn get_counter_ptr() *u8 {
    return &counter;
}

// 3. We also keep a function to modify it from Zig, to prove it's the same data.
export fn increment() void {
    counter += 1;
}
