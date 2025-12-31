# Tutorial 05: Arrays and Slices

## Goal
Learn how to pass and process arrays of numbers in WebAssembly efficiently.

## Concepts
Zig has **Slices** (`[]T`), which are a `(pointer, length)` pair.
WebAssembly memory is untyped bytes. JavaScript has typed arrays (`Int32Array`, `Float32Array`) that can "view" the underlying buffer.

To share an array:
1.  Establish a location in Wasm memory (a pointer).
2.   JS copies data to that location.
3.   Zig reads/writes that location using a slice.
4.   JS reads the result.

## 1. Zig Code
We use a fixed buffer again for simplicity.

```zig
var buffer: [100]i32 = undefined;

export fn get_buffer_ptr() [*]i32 {
    return &buffer;
}

export fn process_array(len: usize) void {
    // Turn pointer + len into a slice
    const slice = buffer[0..len];
    for (slice) |*item| {
        item.* *= 2; // Mutate in place
    }
}
```

## 2. JavaScript Code
Using `Int32Array` on `memory.buffer`.

**Important**: Pointers are byte offsets. If we point to an `i32` array at byte 100, that is index `25` in an `Int32Array` (since 100 / 4 = 25). `new Int32Array(buffer, offset, length)` handles this if we pass the byte offset.

```javascript
const ptr = exports.get_buffer_ptr(); // address in bytes
const len = 5;

// Create a view.
// ptr is a BYTE index. Int32Array constructor takes a BYTE offset.
const wasmArr = new Int32Array(exports.memory.buffer, ptr, len);

// Copy input
wasmArr.set([1, 2, 3, 4, 5]);

// Process
exports.process_array(len);

// Read back (wasmArr is a live view, so it sees the update!)
console.log(wasmArr); // [2, 4, 6, 8, 10]
```

## Zero-Copy?
Technically, `wasmArr.set([...])` is a copy from JS heap to Wasm memory. But once inside Wasm memory, Zig operates on it directly, and the `wasmArr` view sees the changes instantly without another copy.

## try it
Run `./build.sh` and open `05-arrays-slices.html`.
