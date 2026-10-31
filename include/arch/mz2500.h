/*
 * Header file for Sharp MZ-2500 specific stuff
 *
 * $Id: mz2500.h $
 *
 * The Z80's 64 KB is eight 8 KB windows; each is mapped to one of the 8 KB pages of the machine's memory:
 *   $00-$1F RAM (256 KB), $20-$2F video RAM, $30-$33 video read-modify-write, $34-$37 IPL ROM, $38 text VRAM, $39 PCG/kanji.
 * Video RAM is four planes (blue, red, green, intensity); in 320x200x16 a plane is 40 bytes a line, bit 0 of a byte is
 * the leftmost pixel and the pixel value is B | R << 1 | G << 2 | I << 3.
 *
 * Build options: -pragma-define:CRT_MZ2500_IPL_DISABLED=1 leaves the memory map and the text screen as the loader set them (no IPL calls at startup).
 * Extra RAM pages are loaded with the program by naming a linker section BANK_<page> (org (page << 16) | address, at most 8 KB).
 */

#ifndef __MZ2500_H__
#define __MZ2500_H__

#include <sys/compiler.h>
#include <stdint.h>

// Map a page into a window (0-7); interrupts are held off for the two port writes
extern void __LIB__ mz2500_map_page(uint8_t window, uint8_t page) __smallc;

// The page mapped in a window
extern uint8_t __LIB__ mz2500_get_page(uint8_t window) __z88dk_fastcall;

// Map the B, R, G, I planes of video screen 0-3 (A-D) into four windows from first_window (0-4)
extern void __LIB__ mz2500_map_planes(uint8_t first_window, uint8_t screen) __smallc;

// Write a graphics (CG) register
extern void __LIB__ mz2500_cg_set(uint8_t reg, uint8_t value) __smallc;

// Graphics mode and a full screen view: $14/$15 = 320x200 16 colours.  Returns 1 if the mode is not supported
extern int __LIB__ mz2500_set_mode(uint8_t mode) __z88dk_fastcall;

// Palette entry 0-15 to a 4096 colour value (r, g, b = 0-15)
extern void __LIB__ mz2500_set_palette(uint8_t n, uint8_t r, uint8_t g, uint8_t b) __smallc;

// Which palette entry a pixel value 0-15 shows
extern void __LIB__ mz2500_set_pixel_palette(uint8_t pixel, uint8_t entry) __smallc;

// Displayed planes: low nibble screen A (B, R, G, I), high nibble screen B
extern void __LIB__ mz2500_set_display_planes(uint8_t mask) __z88dk_fastcall;

// Start address of the display in the planes (hardware scroll)
extern void __LIB__ mz2500_set_start_address(uint16_t addr) __z88dk_fastcall;

// Wait for the start of the vertical blanking
extern void __LIB__ mz2500_wait_vblank(void);

// Read (write = 0) or write (1) one 256 byte sector (ID 1-16) by driving the floppy controller directly: 0 = done, else the controller's error bits.
// Interrupts must be off.  The motor stays on until mz2500_disk_off()
extern int __LIB__ mz2500_disk_rw(uint8_t write, uint8_t drive, uint8_t cylinder, uint8_t head, uint8_t sector, void *buf) __smallc;
extern void __LIB__ mz2500_disk_off(void);

// The mouse (the SIO's channel B), as in input.h: buttons are 00000MRL active high, the position is 0..319 by 0..199.  The movement the mouse has sent
// since the last call is added to the position, so call in_MouseMZ2500 once a frame or so; in_MouseMZ2500SetPos moves it.  A mouse cannot be detected:
// in_MouseMZ2500Init (position to 0,0) always returns non-zero.
extern int  __LIB__ in_MouseMZ2500Init(void);
extern int  __LIB__ in_MouseMZ2500Present(void);
extern void __LIB__ in_MouseMZ2500(unsigned char *buttons, unsigned int *xcoord, unsigned int *ycoord) __smallc;
extern void __LIB__ in_MouseMZ2500SetPos(unsigned int xcoord, unsigned int ycoord) __smallc;

extern void __LIB__ in_MouseMZ2500_callee(unsigned char *buttons, unsigned int *xcoord, unsigned int *ycoord) __smallc __z88dk_callee;
extern void __LIB__ in_MouseMZ2500SetPos_callee(unsigned int xcoord, unsigned int ycoord) __smallc __z88dk_callee;

#define in_MouseMZ2500(a,b,c)     in_MouseMZ2500_callee(a,b,c)
#define in_MouseMZ2500SetPos(a,b) in_MouseMZ2500SetPos_callee(a,b)

// Keyboard: in_Inkey, in_KeyPressed and in_LookupKey as in input.h.  A scan code is the column (0-11) in the low byte, with bit 7 set if SHIFT has to be down
// and bit 6 if CTRL has to be down (the modifiers must be as it says), and the key's bit in the high byte.  The modifiers' own keys (their column ignores
// what else is down):
#define IN_KEY_SCANCODE_GRPH   0x010B
#define IN_KEY_SCANCODE_SLOCK  0x020B
#define IN_KEY_SCANCODE_SHIFT  0x040B
#define IN_KEY_SCANCODE_KANA   0x080B
#define IN_KEY_SCANCODE_CTRL   0x100B

#endif
