# Tutorial 03: WebAssembly Memory Basics

## Goal
Understand how WebAssembly memory works.
**Spoiler:** It's just a giant array of bytes that both Zig and JavaScript can read and write to!

## 1. Concepts: Linear Memory & Pointers
In many high-level languages (JS, Python), "memory" is abstract. You create objects and variables, and the language handles the rest.

In **C, Zig, and WebAssembly**, memory is **Linear**. Think of it as a single, long street with houses numbered 0, 1, 2, 3...
- Each "house" can hold 1 byte (0-255).
- The address of the house is called a **Pointer**.

If we have a variable `counter` stored at house #100:
- The **value** might be `5`.
- The **pointer** is `100`.

## 2. Zig Code
We will create a global variable and export its *pointer* (address) to JavaScript.

`src/03-wasm-memory.zig`:
```zig
// 1. A global variable. It lives somewhere in linear memory.
var counter: u8 = 0;

// 2. Return the address (index) of this variable.
export fn get_counter_ptr() *u8 {
    return &counter;
}

// 3. A function to change the value from Zig side.
export fn increment() void {
    counter += 1;
}
```

## 3. JavaScript Code
To touch this memory, we access `exports.memory.buffer`.

`public/03-wasm-memory.html`:
```javascript
WebAssembly.instantiateStreaming(fetch('03-wasm-memory.wasm'), {})
    .then(obj => {
        const exports = obj.instance.exports;
        
        // 1. Get the Big Memory Array
        const memory = exports.memory;
        
        // 2. Ask Zig where the variable is
        const counterPtr = exports.get_counter_ptr();
        console.log("Counter is at index:", counterPtr);

        // 3. Create a view to read/write bytes
        // Uint8Array means "treat this buffer as a list of bytes"
        const bytes = new Uint8Array(memory.buffer);
        
        // READ:
        console.log("Value:", bytes[counterPtr]); 
        
        // WRITE:
        bytes[counterPtr] = 42; 
        
        // Zig sees the change immediately!
        exports.increment(); // 42 -> 43
    });
```

## 4. Build & Run
Update `build.sh` and run it.
Open `http://localhost:8000/03-wasm-memory.html`.

You will see that you can read the value, change it from JS, and Zig will respect that change. **There is no copying of data, it is literally the same memory.**
