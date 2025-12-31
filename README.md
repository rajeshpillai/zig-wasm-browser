# Zig Wasm Browser Tutorials

Welcome! This repository contains a series of step-by-step tutorials to help you learn how to use **Zig** to create **WebAssembly (Wasm)** modules that interact with the browser (HTML5 Canvas, DOM, etc.).

Our goal is to build up from "Hello World" to a functional game or graphics application, one tiny concept at a time.

## Prerequisites
- **Zig Compiler**: Install the latest version from [ziglang.org](https://ziglang.org/download/).
- **Web Browser**: Any modern browser (Chrome, Firefox, Safari, Edge).
- **Local Server**: Required to serve Wasm files (e.g., Python 3, Node `http-server`, or VS Code Live Server).

## Quick Start

1.  **Clone the repo**:
    ```bash
    git clone https://github.com/rajeshpillai/zig-wasm-browser.git
    cd zig-wasm-browser
    ```

2.  **Build everything**:
    ```bash
    ./build.sh
    ```
    This compiles all Zig sources in `src/` to Wasm files in `public/`.

3.  **Run**:
    ```bash
    cd public
    # Using Python 3
    python3 -m http.server
    # OR using npx
    npx serve .
    ```

4.  **Visit**: Open your browser to `http://localhost:8000` (or `http://localhost:3000` depending on your server).

## Tutorials

| Index | Title | Code | Description |
| :--- | :--- | :--- | :--- |
| **00** | [Introduction](tutorials/00-introduction.md) | N/A | Overview of Zig and WebAssembly. |
| **01** | [Hello World](tutorials/01-hello-world.md) | [zig](src/01-hello-world.zig) / [html](public/01-hello-world.html) | Exporting a function from Zig to JS. |
| **02** | [Importing JS](tutorials/02-js-imports.md) | [zig](src/02-js-imports.zig) / [html](public/02-js-imports.html) | Calling JavaScript functions from Zig. |
| **03** | [Memory Basics](tutorials/03-wasm-memory.md) | [zig](src/03-wasm-memory.zig) / [html](public/03-wasm-memory.html) | Understanding linear memory and pointers. |
| **04** | [Passing Strings](tutorials/04-passing-strings.md) | [zig](src/04-passing-strings.zig) / [html](public/04-passing-strings.html) | Sending/Receiving text via TextEncoder/Decoder. |
| **05** | [Arrays & Slices](tutorials/05-arrays-slices.md) | [zig](src/05-arrays-slices.zig) / [html](public/05-arrays-slices.html) | Processing numeric arrays (Int32Array). |
| **06** | [Canvas Basics](tutorials/06-canvas-basics.md) | [zig](src/06-canvas-basics.zig) / [html](public/06-canvas-basics.html) | Pixel buffers and ImageData. |
| **07** | [Drawing Shapes](tutorials/07-drawing-shapes.md) | [zig](src/07-drawing-shapes.zig) / [html](public/07-drawing-shapes.html) | Drawing lines, rectangles, and circles in software. |
| **08** | [Animation Loop](tutorials/08-animation-loop.md) | [zig](src/08-animation-loop.zig) / [html](public/08-animation-loop.html) | Bouncing ball with persistent state & game loop. |

## License
MIT
