/*
 * Headerfile for NEC PC-8001 specific stuff
 *
 * The PC-8001 has a Z80 at 4 MHz, a uPD3301 CRT controller, a uPD8257 DMA
 * controller, an 8251 USART for the cassette and a one bit beeper. The mkII
 * (the mk2 clib) adds graphics RAM.
 *
 * Text screen: the DMA controller feeds the CRTC from $F300. A row is 80
 * characters then 20 attribute pairs (a start column and an attribute): 120
 * bytes a row, 25 rows. An attribute holds from its start column to the start
 * of the next pair and a start column of $80 ends the list.
 *
 * Screen modes of console_ioctl(IOCTL_GENCON_SET_MODE):
 *   0   80x25 text with 160x100 semigraphics
 *   1   40x25 text with 80x100 semigraphics
 *   2   80x25 with 640x200 mono graphics      (-clib=mk2)
 *   3   40x25 with 320x200 4 colour graphics  (-clib=mk2)
 * Add 32 to mode 3 for the other colour set: blue, magenta and cyan in place
 * of black, red and green (pixel value 3 is white in both).
 * In modes 2 and 3 text is drawn as bitmaps on the graphics screen when a font
 * has been set (-pragma-redirect:CRT_FONT= or IOCTL_GENCON_SET_FONT32).
 *
 * N-BASIC keeps copies of the write only ports: $EA66 is port $30, $EA67 is
 * port $40 and, on the mkII, $E6C6 is port $31.
 */

#ifndef __ARCH_PC8001_H__
#define __ARCH_PC8001_H__

#include <sys/compiler.h>
#include <sys/types.h>

// Text screen
#define SCREEN_TXT_BASE   0xf300
#define SCREEN_ROW_BYTES  120
#define SCREEN_ATTR_BASE  (SCREEN_TXT_BASE + 80)

// Attribute bits. A semigraphic cell shows its character as a block of 2x4
// pixels: bits 0 - 3 are the left half, from the top down, bits 4 - 7 the
// right half
#define ATTR_SEMIGFX    0x80
#define ATTR_LOWERLINE  0x20
#define ATTR_UPPERLINE  0x10
#define ATTR_REVERSE    0x04
#define ATTR_BLINK      0x02
#define ATTR_SECRET     0x01

// The mkII (-clib=mk2) has colour text, which uses a second form of attribute.
// With bit 3 set the attribute is a colour: bits 7 - 5 are green, red and
// blue, and bit 4 is a semigraphic cell. With bit 3 clear it is a decoration,
// the bits above except for bit 7. A row starts with white.
#define ATTR_COLOUR     0x08
#define ATTR_COLOUR_SEMIGFX  0x10
#define ATTR_COLOUR_BLUE     0x20
#define ATTR_COLOUR_RED      0x40
#define ATTR_COLOUR_GREEN    0x80

// mkII graphics RAM, three planes paged in over $8000 - $BFFF with the planes
// selection ports below. A pixel row is 80 bytes and there are 200 rows. Code
// that runs with a plane paged in has to be outside that range. The mk2 clib
// does this: its routines are at the start of the program
#define GVRAM_BASE 0x8000

// Keyboard: row n of the matrix, a key down reads as a 0 bit
__sfr __at 0x00 KB_MATRIX_REG_0;   // 0 - 7 of the keypad
__sfr __at 0x01 KB_MATRIX_REG_1;   // 8 9 * + = , . return of the keypad
__sfr __at 0x02 KB_MATRIX_REG_2;   // @ A - G
__sfr __at 0x03 KB_MATRIX_REG_3;   // H - O
__sfr __at 0x04 KB_MATRIX_REG_4;   // P - W
__sfr __at 0x05 KB_MATRIX_REG_5;   // X Y Z [ yen ] ^ -
__sfr __at 0x06 KB_MATRIX_REG_6;   // 0 - 7
__sfr __at 0x07 KB_MATRIX_REG_7;   // 8 9 : ; , . / _
__sfr __at 0x08 KB_MATRIX_REG_8;   // home up right del grph kana shift ctrl
__sfr __at 0x09 KB_MATRIX_REG_9;   // stop f1 - f5 space esc

// W: the calendar clock (uPD1990AC) and printer data
__sfr __at 0x10 PD_CTL_REG;

// Cassette (8251)
__sfr __at 0x20 USART_DATA_REG;
__sfr __at 0x21 USART_CTL_REG;

/* System control port A (write only)
Bit     7   6   5   4   3       2       1           0
            BS2 BS1 MTON    CDS     /COLOR      /40
BS2 BS1: 00 cassette 600 bps, 01 cassette 1200 bps, 10 RS-232C async, 11 sync
MTON:    cassette motor on
CDS:     cassette carrier, 1 mark, 0 space
/COLOR:  0 colour attributes, 1 monochrome
/40:     1 80 columns per line, 0 40 columns
*/
__sfr __at 0x30 SYS_CTL_REGA;

/* System control port B (mkII only, write only)
Bit     7 6 5       4       3           2       1       0
        colour      320     graphics    mono    RAM     N-BASIC
colour: the colour of the monochrome graphics and of pixel value 3 of the
        320x200 mode, bit 5 blue, bit 6 red, bit 7 green
320:    1 for the 320x200 4 colour screen, two bits a pixel
graphics: graphics on
mono:   the 640x200 graphics screen in the one colour of bits 5 - 7. Without
        it the colour of the 640x200 screen comes from the text attributes
RAM:    the ROM at $0000 - $7FFF is replaced by RAM
N-BASIC: 1 N-BASIC ROM, 0 expansion ROM
*/
__sfr __at 0x31 SYS_CTL_REGB;

/* Port $40
Read:  bit 0 printer busy, 1 printer ack, 2 cassette data in, 3 /EXTON,
       4 calendar clock data out, 5 vertical retrace
Write: bit 0 printer strobe, 1 calendar clock strobe, 2 calendar clock clock,
       3 CRTC clock, 5 the buzzer
The buzzer sounds a tone of fixed pitch for as long as bit 5 is set, the pitch
can't be changed. N-BASIC's BEEP sets the bit for about a quarter of a second.
*/
__sfr __at 0x40 SYS_STATUS_REG;

/* mkII memory control (not in the ROM, as the emulators have it)
Bit     4       3 2 1   0
        write           read
write:  writes go to the RAM under the ROM at $0000 - $7FFF, the ROM is still read
read:   the RAM is read in place of the ROM
Both set, the program has RAM from $0000. Bit 1 of port $31 does both together.
-subtype=allram uses this: its bootstrap loads the program over the ROM.
*/
__sfr __at 0xe2 EXRAM_CTL;

// CRT controller (uPD3301)
__sfr __at 0x50 CRTC_CTLREG_A;     // parameters
__sfr __at 0x51 CRTC_CTLREG_B;     // commands and status

// mkII graphics RAM: any write selects the plane at $8000 - $BFFF (or main
// memory). The planes are displayed ORed together
__sfr __at 0x5c GVRAM_SEL_0;
__sfr __at 0x5d GVRAM_SEL_1;
__sfr __at 0x5e GVRAM_SEL_2;
__sfr __at 0x5f MAINRAM_SEL;

// DMA controller (uPD8257). Channel 2 feeds the CRTC from $F300
__sfr __at 0x64 DMA_CH2_ADDR;
__sfr __at 0x65 DMA_CH2_COUNT;
__sfr __at 0x68 DMA_MODE;

// The scan codes of the modifiers for in_KeyPressed: (key mask << 8) | row of
// the keyboard matrix. The machine has no break key, the stop key is used
#define IN_KEY_SCANCODE_SHIFT  0x4008
#define IN_KEY_SCANCODE_CTRL   0x8008
#define IN_KEY_SCANCODE_GRPH   0x1008
#define IN_KEY_SCANCODE_KANA   0x2008
#define IN_KEY_SCANCODE_BREAK  0x0109

// Switch the buzzer on or off. It sounds a tone of fixed pitch for as long as
// it is on. The other bits of port $40 are kept as N-BASIC has them
extern void __LIB__ pc8001_buzzer(int on) __z88dk_fastcall;

// Disk (the unit's own protocol, no ROM needed). Sectors are 256 bytes, the first on a track is 1 and the
// drives are single sided, so the track is the cylinder. A run of sectors carries on to the next track.
// They return 0, or 1 on an error. Interrupts should be off.
extern int __LIB__ pc8001_disk_read(uint8_t drive, uint8_t track, uint8_t sector, uint8_t count, void *buf) __smallc;
extern int __LIB__ pc8001_disk_write(uint8_t drive, uint8_t track, uint8_t sector, uint8_t count, const void *buf) __smallc;

#endif
