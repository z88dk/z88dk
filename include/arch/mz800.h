/*
 *	Sharp MZ-800 specific functions
 *
 *	$Id: mz800.h $
 */

#ifndef __MZ800_H__
#define __MZ800_H__

#include <sys/compiler.h>
#include <stdint.h>


// Display mode ($CE): 0 = 320x200, 4 pens (planes I and II); 1 = planes III and IV; 4/5 = 640x200 2 colours; 6 = 640x200 4 colours; 8 = MZ-700 text
extern void __LIB__ mz800_set_mode(uint8_t mode) __z88dk_fastcall;

// Palette entry 0-3 (the pixel value in the 4 colour modes) = colour 0-15 (IGRB: 1 blue, 2 red, 4 green, 8 bright)
extern void __LIB__ mz800_set_palette(uint8_t entry, uint8_t colour) __smallc;
extern void __LIB__ mz800_set_palette_callee(uint8_t entry, uint8_t colour) __smallc __z88dk_callee;

// The graphics screen: 320x200, four pens, palette black / bright red / bright green / white.  The video RAM is paged in over $8000-$9FFF (and the character generator over
// $1000-$1FFF) only while a library routine draws: keep code and data out of those ranges (the drawing code is linked first, programs start at $2000)
extern void __LIB__ mz800_gfx_init(void);
// The ink and paper pens (0-3, default 3 and 0) that plot, unplot, xorplot, clg and the console use: textcolor() and textbackground() set the same ones
extern void __LIB__ mz800_gfx_ink(uint8_t ink, uint8_t paper) __smallc;

// Wait for the start of the vertical blank
extern void __LIB__ mz800_wait_vblank(void);

// Read (write = 0) or write (write != 0) one 256 byte sector of a disc by its logical sector number (the IPL's: track = sector / 16,
// cylinder = track / 2, side = track & 1, sector ID = sector % 16 + 1: a boot disc's sector 0 is the IPL header).  Returns 0 or the
// controller's error bits.  Interrupts must be off.  The motor stays on until mz800_disk_off()
extern int __LIB__ mz800_disk_rw(uint8_t write, uint8_t drive, uint16_t sector, void *buf) __smallc;
extern void __LIB__ mz800_disk_off(void);


// The modifiers' scan codes for in_KeyPressed: (key mask << 8) | strobe (strobe 8 of the keyboard matrix)
#define IN_KEY_SCANCODE_SHIFT  0x0108
#define IN_KEY_SCANCODE_CTRL   0x4008
#define IN_KEY_SCANCODE_BREAK  0x8008

#endif
