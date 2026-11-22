#ifndef __ARCH_SPC1500_H__
#define __ARCH_SPC1500_H__

#include <sys/compiler.h>
#include <stdint.h>
#include <stddef.h>

/*
 *	Samsung SPC-1500 (Z80 at 4 MHz, 64 KB RAM, MC6845 CRTC, AY-3-8910,
 *	three bit planes)
 *
 *	The video memory is behind the I/O ports: the full 16 bit port
 *	address is decoded, so OUT (C),A / IN A,(C) with BC = the address.
 *
 *	$1000, $1100, $1200  palette (blue, red, green)
 *	$1300                plane priority
 *	$1800 / $1801        MC6845 address / data
 *	$1900 + n            keyboard row n (0-9)
 *	$1A00-$1A03          8255: port B bit 1 tape in, bit 7 vsync; port C
 *	                     bit 0 tape out, bit 5 double access, bit 6 40
 *	                     columns
 *	$1B00 / $1C00        AY-3-8910 data / address
 *	$1D00                select the IPL ROM at $0000-$7FFF
 *	$1E00                select RAM
 *	$2000, $3000         text attributes, character codes
 *	$4000, $8000, $C000  the blue, red and green bit planes: byte
 *	                     offset = (y & 7) * $800 + (y >> 3) * 80 + x / 8
 *	                     (40 in the 40 column mode), bit 7 leftmost
 *
 *	Writing to an address below $4000 while the 8255's port C bit 5 has
 *	just been set (double access) stores the byte in all three planes
 *	at that offset; any I/O read ends it.
 */

// Select the IPL ROM or RAM for reads at $0000-$7FFF (stores always go to RAM):
// while the ROM is paged in the program's own code and data below $8000 are
// hidden
extern void __LIB__ spc1500_rom_select(void);
extern void __LIB__ spc1500_ram_select(void);

// The graphics screen: the 40 column mode, 320x200, eight colours (the pen is
// the colour: 1 blue, 2 red, 4 green), the palette pen n = colour n, the text
// layer cleared.
// The ink and paper pens (0-7, default 7 and 0) that plot, unplot, xorplot, clg
// and the console use: textcolor() and textbackground() set the same ones
extern void __LIB__ spc1500_gfx_init(void);
extern void __LIB__ spc1500_gfx_ink(uint8_t ink, uint8_t paper) __smallc;

// Pen 0-7 (the value of a pixel's three plane bits) = colour 0-7
extern void __LIB__ spc1500_set_palette(uint8_t pen, uint8_t colour) __smallc;

// Wait for the start of the vertical blank (the 8255's port B bit 7 falling)
extern void __LIB__ spc1500_wait_vblank(void);

// The cassette, in the machine's own format (the one the IPL's "C: cassette
// system" loads).  A file is two blocks: a header (the name, up to 14
// characters, the length, and up to 96 bytes of the program's own: user and
// ulen) and the data.  save returns 0, or -1 if the player stopped it (Shift
// and Break together).  load_to passes over files with other names, gives back
// the header's user bytes and reads the data into buf: it returns the bytes
// read (len if the file is whole) or -1 if no header was read.  The player
// presses PLAY (and RECORD to save); the motor is turned on and off through
// the AY's port B.  Interrupts are off while they work.
extern int __LIB__ spc1500_tape_save(const char *name, const void *addr, size_t len, const void *user, size_t ulen) __smallc;
extern int __LIB__ spc1500_tape_load_to(const char *name, void *buf, size_t len, void *user, size_t ulen) __smallc;

// The modifiers' scan codes for in_KeyPressed: (key mask << 8) | row (row 0 of
// the keyboard matrix)
#define IN_KEY_SCANCODE_SHIFT  0x0200
#define IN_KEY_SCANCODE_CTRL   0x0400
#define IN_KEY_SCANCODE_BREAK  0x1000

#endif
