# Tutorial 00: Introduction

## Goals
The goal of this series is to learn and teach how to use **Zig** to create **WebAssembly (Wasm)** modules that interact with the browser, specifically focusing on **HTML5 Canvas** for graphics and eventual game development.

We will approach this by building tiny, working examples, one concept at a time.

## Prerequisites
- Basic understanding of programming.
- **Zig** compiler installed (latest stable or master).
- A modern web browser.
- A text editor (VS Code, Vim, etc.).

## What is Zig?
Zig is a general-purpose programming language and toolchain for maintaining robust, optimal and reusable software. It is great for Wasm because:
- No hidden control flow.
- No hidden memory allocations.
- First-class Wasm support.
- Great interoperability with C (if needed).

## What is WebAssembly?
WebAssembly (Wasm) is a binary instruction format for a stack-based virtual machine. It is designed as a portable compilation target for programming languages, enabling deployment on the web for client and server applications.

## Project Structure
- `src/`: Contains the Zig source code.
- `public/`: Contains the HTML, JS, and compiled Wasm files.
- `tutorials/`: Contains these markdown tutorials.
- `build.sh`: A simple script to build our examples.

In the next tutorial, we will write our first "Hello World" program.
