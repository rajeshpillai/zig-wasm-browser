const std = @import("std");

// A fixed-size buffer to use as workspace for this example.
// (In real apps, use an allocator or pass pointers directly if memory is already managed)
var input_buffer: [100]i32 = undefined;

// Export pointer to the input buffer
export fn get_input_buffer_ptr() [*]i32 {
    return &input_buffer;
}

// Function to process the array: Multiplies each element by 2
export fn process_array(len: usize) void {
    const slice = input_buffer[0..len];
    for (slice) |*item| {
        item.* *= 2;
    }
}
