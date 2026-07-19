/*
 * Generic Intel 8275 Programmable CRT Controller
 *
 * Command encodings and screen-composition parameter builders straight from
 * the 1984 datasheet, plus an RC700 preset and easy init helpers.
 *
 * Datasheet: Intel 8275 Programmable CRT Controller (1984)
 *   https://bitsavers.org/components/intel/8275/1984_8275.pdf
 * Application note (AP-62, 8275 in an 8085 system):
 *   https://bitsavers.org/components/intel/8275/1984_AP-62.pdf
 * RC700 issue: https://github.com/z88dk/z88dk/issues/3011
 */

#ifndef __VIDEO_I8275_H__
#define __VIDEO_I8275_H__

#include <sys/compiler.h>

/* -------- Command bytes (written to the command port, A0 = 1) --------
 * Bits 7:5 select the command; the low bits are command-specific. */
#define I8275_CMD_RESET          0x00  /* + 4 screen-composition parameter bytes */
#define I8275_CMD_START_DISPLAY  0x20  /* | burst config, see I8275_START()      */
#define I8275_CMD_STOP_DISPLAY   0x40
#define I8275_CMD_READ_LIGHT_PEN 0x60
#define I8275_CMD_LOAD_CURSOR    0x80  /* + column, row data bytes               */
#define I8275_CMD_ENABLE_INT     0xA0
#define I8275_CMD_DISABLE_INT    0xC0
#define I8275_CMD_PRESET         0xE0

/* -------- Reset parameter builders (datasheet bit layout) --------
 * The four bytes follow an I8275_CMD_RESET, written to the data port. */

/* par0 = S HHHHHHH : spaced rows + chars-per-row.  chars_per_row 1..80. */
#define I8275_PAR0(spaced, chars_per_row) \
    (((spaced) ? 0x80 : 0x00) | (((chars_per_row) - 1) & 0x7F))

/* par1 = VV RRRRRR : VRTC row-count (1..4) + rows-per-frame (1..64). */
#define I8275_PAR1(vrtc_rows, rows_per_frame) \
    (((((vrtc_rows) - 1) & 0x03) << 6) | (((rows_per_frame) - 1) & 0x3F))

/* par2 = UUUU LLLL : underline scan line (0..15) + lines-per-char-row (1..16). */
#define I8275_PAR2(underline_line, lines_per_row) \
    ((((underline_line) & 0x0F) << 4) | (((lines_per_row) - 1) & 0x0F))

/* par3 = M F CC ZZZZ : line-counter mode, field-attribute mode,
 * cursor format (0..3), horizontal-retrace char count (2..32, even). */
#define I8275_PAR3(line_mode, field_attr, cursor_fmt, hrtc_chars) \
    (((line_mode) ? 0x80 : 0x00) | ((field_attr) ? 0x40 : 0x00) | \
     (((cursor_fmt) & 0x03) << 4) | ((((hrtc_chars) / 2) - 1) & 0x0F))

/* Start Display command byte from burst-space (0..7) and burst-count (0..3) codes. */
#define I8275_START(space_code, count_code) \
    (I8275_CMD_START_DISPLAY | (((space_code) & 0x07) << 2) | ((count_code) & 0x03))

/* Cursor format = par3 bits 5:4 (the cursor_fmt argument to I8275_PAR3). */
enum i8275_cursor_format {
    I8275_CURSOR_BLINK_BLOCK      = 0,  /* blinking reverse-video block */
    I8275_CURSOR_BLINK_UNDERLINE  = 1,  /* blinking underline */
    I8275_CURSOR_STEADY_BLOCK     = 2,  /* steady reverse-video block */
    I8275_CURSOR_STEADY_UNDERLINE = 3   /* steady underline */
};

/* -------- RC700 preset --------
 * Fixed 80x25 geometry; the compiled helpers use these ports. */
#define I8275_RC700_CMD_PORT   0x01
#define I8275_RC700_DATA_PORT  0x00

#define I8275_RC700_PAR0   0x4F  /* I8275_PAR0(0, 80)                       */
#define I8275_RC700_PAR1   0x98  /* I8275_PAR1(3, 25)                       */
#define I8275_RC700_PAR2   0x7A  /* I8275_PAR2(7, 11)                       */
#define I8275_RC700_PAR3   0x4D  /* I8275_PAR3(0, 1, I8275_CURSOR_BLINK_BLOCK, 28) */
#define I8275_RC700_START  0x23  /* I8275_START(0, 3): burst 8, space 0     */

/* Fill par[4] with the RC700 defaults (blinking block cursor).  Gives the
 * caller a valid parameter block from one call, to override selectively
 * before i8275_reset(). */
extern void __LIB__ i8275_default_par(unsigned char *par) __z88dk_fastcall;

/* Reprogram the RC700 8275 from par[4] and re-enable the display:
 * reset + parameters, load cursor to (0,0), preset counters, start display. */
extern void __LIB__ i8275_reset(unsigned char *par) __z88dk_fastcall;

#endif
