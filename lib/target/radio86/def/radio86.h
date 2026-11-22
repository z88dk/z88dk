
// Monitor entry points for Radio86


#define M_COLD_BOOT	0xf800

// Read keyboard: a = code read
#define M_WAITKEY	0xf803

// Read a byte from tape
//  Input : A=0FFh - with sync; A=08h - no sync
//  Output: A - data read from cassette
#define M_TAPE_READ	0xf806

// Print character to screen
// Input: C - character to print
// Output: None
#define M_PUTCHAR	0xf809


// Query keyboard
// Input: None
// Output: a = $00 not pressed, a = $ff pressed
#define M_QUERYKEY	0xf812

// Print to screen in hex
// Input: a - data to print
// Output: None
#define	M_PRINT_HEX	0xf815

// Print a string to screen (\0 temrinated)
// Input: hl = address of string
#define M_PRINTSTR	0xf818

// Read keyboard
// Output: a = code read, ff=nokey, fe=rus/lat
#define M_GETKEY	0xf81b

// Get cursor position
// Output: H - row, L - column
#define M_GETCURS	0xf81e

// Read character from screen at current cursor
// Output: a = character
#define	M_VPEEK		0xf821

// Read from tape
// Input: hl = memory buffer to store data to
// Output: hl = start, de = end, bc = checksum
#define M_TAPE_RD_BLK	0xf824

// Write to tape
// Input: hl = start, de = end
// Output: bc = checksum
#define M_TAPE_WR_BLK	0xf827

// Calculate checksum
// Input: hl = start, de = end
// Output: bc = checksum
#define M_CHECKSUM	0xf82a

// Iniitiase deisplay
#define M_INIT_SCREEN	0xf82d

// Get memory heap
// Input: none
// Output: hl = highest address available for program
#define	M_GET_HEAP	0xf830

// Get memory heap
// Input: none
// Output: hl = highest address available for program
#define	M_SET_HEAP	0xf833

