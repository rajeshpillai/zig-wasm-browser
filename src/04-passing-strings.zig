const std = @import("std");

// Import a JS function that takes a pointer and a length
extern "env" fn console_log(ptr: [*]const u8, len: usize) void;

// Define a static string
const greeting = "Hello from Zig (String)!";

// Export pointer to the string
export fn get_greeting_ptr() [*]const u8 {
    return greeting.ptr;
}

// Export length of the string
export fn get_greeting_len() usize {
    return greeting.len;
}

// A buffer for receiving strings from JS (simple approach for now)
var input_buffer: [100]u8 = undefined;

// Export pointer to input buffer
export fn get_input_buffer_ptr() [*]u8 {
    return &input_buffer;
}

// Function to print the input buffer
export fn print_input_buffer(len: usize) void {
    // Slice the buffer to the given length
    const message = input_buffer[0..len];
    console_log(message.ptr, message.len);
}
