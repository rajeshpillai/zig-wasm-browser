const std = @import("std");

// Minimal 8x8 Font for ASCII (Space to ~)
// Each u64 represents 8 rows of 8 pixels.
// To save space in this tutorial, we will use a generated block for simplicity 
// in a real app, you'd paste a full table here.
// For this tutorial, we'll implement a helper that returns a "blocky" checkboard for unknown chars
// and actual patterns for a few key letters if possible, or just a generic placeholder logic
// for the user to fill in, or a very small subset.

// Actually, let's include a tiny subset (numbers + uppercase) compressed.
// 0=Transparent, 1=Set
// We will iterate bits.

pub fn get_char_bitmap(c: u8) u64 {
    // 8x8 bitmap packed into u64 (row by row)
    // MSB top-left
    
    switch (c) {
        'A' => return 0x183C667E66666600,
        'B' => return 0x7C667C667C667C00,
        'C' => return 0x3C66606060663C00,
        'D' => return 0xF86C6666666CF800,
        'E' => return 0x7E607C607E607E00,
        'F' => return 0x7E607C6060606000,
        'G' => return 0x3C66606E66663C00,
        'H' => return 0x66667E6666666600,
        'I' => return 0x3C18181818183C00,
        'J' => return 0x0606060606663C00,
        'K' => return 0x666C7870786C6600,
        'L' => return 0x6060606060607E00,
        'M' => return 0xC6EEE6D6C6C6C600,
        'N' => return 0xC6E6F6DECEC6C600,
        'O' => return 0x3C66666666663C00,
        'P' => return 0x7C66667C60606000,
        'Q' => return 0x3C666666666C3600,
        'R' => return 0x7C66667C786C6600,
        'S' => return 0x3C66603C06663C00,
        'T' => return 0x7E18181818181800,
        'U' => return 0x6666666666663C00,
        'V' => return 0x66666666663C1800,
        'W' => return 0xC6C6C6D6E6EEC600,
        'X' => return 0xC66C3838386CC600,
        'Y' => return 0x6666663C18181800,
        'Z' => return 0x7E060C1830607E00,
        '0' => return 0x3C666E7666663C00,
        '1' => return 0x1818381818187E00,
        '2' => return 0x3C66060C30607E00,
        '3' => return 0x3C66061C06663C00,
        '4' => return 0x0C1C3C6C7E0C0C00,
        '5' => return 0x7E607C0606663C00,
        '6' => return 0x3C66607C66663C00,
        '7' => return 0x7E060C1830303000,
        '8' => return 0x3C66663C66663C00,
        '9' => return 0x3C66663E06663C00,
        ' ' => return 0x0000000000000000,
        else => return 0xFF8181818181FF00, // Box for unknown
    }
}
