# Tutorial 02: Importing JavaScript Functions

## Goal
Learn how to call JavaScript functions *from* Zig. This is essential for interactivity, logging, and manipulating the DOM indirectly.

## 1. The Zig Code
Create `src/02-js-imports.zig`:

```zig
// Import a function 'print' from the module 'env'
extern "env" fn print(value: i32) void;

export fn add(a: i32, b: i32) i32 {
    const result = a + b;
    // Call the JS function
    print(result);
    return result;
}
```

- `extern "env"` tells Zig to look for the function `print` in the `env` module provided by the host (JavaScript).

## 2. The JavaScript Code
To provide this function, we pass an `importObject` to `WebAssembly.instantiateStreaming`.

`public/02-js-imports.html`:

```javascript
const importObject = {
    env: {
        print: (value) => {
            console.log(`[Zig says]: Value is ${value}`);
        }
    }
};

WebAssembly.instantiateStreaming(fetch('02-js-imports.wasm'), importObject)
    // ...
```

## 3. Compilation
Add to `build.sh`:

```bash
zig build-exe src/02-js-imports.zig -target wasm32-freestanding -O ReleaseSmall -fno-entry --export=add -rdynamic --name 02-js-imports
mv 02-js-imports.wasm public/
```

## 4. Result
When you run this page and look at the console, you will see the log coming from the Zig call!
