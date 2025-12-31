# Tutorial 01: Hello World

## Goal
Create a minimal Wasm module using Zig that exports a function `add(a, b)` and call it from JavaScript.

## 1. The Zig Code
Create `src/01-hello-world.zig`:

```zig
export fn add(a: i32, b: i32) i32 {
    return a + b;
}
```

- `export` keyword makes the function available to the host (browser).
- We use `i32` which maps directly to Wasm's `i32` type.

## 2. Compilation
To compile this for the browser, we need to target `wasm32-freestanding`.

Command:
```bash
zig build-exe src/01-hello-world.zig -target wasm32-freestanding -O ReleaseSmall -fno-entry --export=add -rdynamic --name 01-hello-world
```

- `-target wasm32-freestanding`: Compile for WebAssembly without an OS.
- `-O ReleaseSmall`: Optimize for small binary size.
- `-fno-entry`: We don't have a `main` function.
- `--export=add`: Explicitly export the `add` symbol (sometimes needed depending on Zig version/optimizations, though `export fn` usually handles it).
- `-rdynamic`: Ensures exported symbols are kept.

This generates `01-hello-world.wasm`.

## 3. The HTML & JavaScript
Create `public/01-hello-world.html`:

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Zig Wasm Hello World</title>
</head>
<body>
    <h1>Zig Wasm Hello World</h1>
    <div id="result"></div>
    <script>
        WebAssembly.instantiateStreaming(fetch('01-hello-world.wasm'), {})
            .then(obj => {
                const add = obj.instance.exports.add;
                const res = add(2, 3);
                console.log('2 + 3 =', res);
                document.getElementById('result').innerText = `Result from Zig: 2 + 3 = ${res}`;
            });
    </script>
</body>
</html>
```

## 4. Running it
You cannot open the HTML file directly due to CORS restrictions on `fetch`. You must serve it via a local server.

```bash
# In the public/ directory
python3 -m http.server

OR

npx serve .
```

Open `http://localhost:8000/01-hello-world.html` and you should see the result.
