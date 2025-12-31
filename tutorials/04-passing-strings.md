# Tutorial 04: Passing Strings

## Goal
Learn how to pass strings between Zig and JavaScript.

## The Problem
WebAssembly only has numbers (`i32`, `f64`, etc.). It does not have a "String" type.
To pass a string, we must pass:
1.  A **pointer** to the start of the bytes.
2.  The **length** of the string.

And we must carry out **encoding/decoding** (UTF-8) on the JavaScript side.

## 1. Zig -> JavaScript
Zig stores strings as UTF-8 bytes. We can return pointers to them.

**Zig Side:**
```zig
const greeting = "Hello!";
export fn get_str_ptr() [*]const u8 { return greeting.ptr; }
export fn get_str_len() usize { return greeting.len; }
```

**JS Side:**
```javascript
const ptr = exports.get_str_ptr();
const len = exports.get_str_len();
const bytes = new Uint8Array(exports.memory.buffer, ptr, len);
const str = new TextDecoder().decode(bytes);
```

## 2. JavaScript -> Zig
To send a string to Zig, we need a place to put it.
1.  **Encode** the JS string to bytes.
2.  **Copy** those bytes into Wasm memory.
3.  Tell Zig where they are.

For this simple tutorial, we use a fixed buffer in Zig (`input_buffer`). In advanced apps, you would use an allocator.

**JS Side:**
```javascript
const encoder = new TextEncoder();
const bytes = encoder.encode("Hello Zig!");
const destPtr = exports.get_input_buffer_ptr(); // predefined buffer address
const memoryView = new Uint8Array(exports.memory.buffer);
memoryView.set(bytes, destPtr);
exports.print_input_buffer(bytes.length);
```

**Zig Side:**
```zig
extern "env" fn console_log(ptr: [*]const u8, len: usize) void;

export fn print_input_buffer(len: usize) void {
    const slice = input_buffer[0..len];
    console_log(slice.ptr, slice.len);
}
```

## Try it out
Run `./build.sh` and open `04-passing-strings.html`. You will be able to fetch a string from Zig and send one back!
