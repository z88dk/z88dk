include(__link__.m4)

#ifndef __NIRVANA_PLUS_H__
#define __NIRVANA_PLUS_H__

/* ----------------------------------------------------------------
 * Z88DK INTERFACE LIBRARY FOR NIRVANA+ ENGINE - by Einar Saukas
 *
 * If you use this interface library, you must load afterwards the
 * NIRVANA+ ENGINE and a bicolor tile set. For a detailed sample
 * see file "nirvanadem.c".
 * ----------------------------------------------------------------
 */

// ----------------------------------------------------------------
// Activate NIRVANA ENGINE
// ----------------------------------------------------------------

__OPROTO(void,,NIRVANAP_start,void)

// ----------------------------------------------------------------
// Deactivate NIRVANA ENGINE
// ----------------------------------------------------------------

__OPROTO(void,,NIRVANAP_stop,void)

// ----------------------------------------------------------------
// Execute HALT (wait for next frame).
//
// If an interrupt occurs while certain routines are under execution
// the program may crash (routines NIRVANAP_fillT, NIRVANAP_drawT and
// NIRVANAP_drawW), or a sprite may be displayed at an incorrect
// location (routine NIRVANAP_spriteT).
//
// Routine NIRVANAP_halt can be used to avoid these problems.
// Immediately after calling it, your program will have some time
// (about 12.5K T) to execute a few other routines without any
// interruption.
// ----------------------------------------------------------------

#ifdef __SDCC

#define NIRVANAP_halt()  __asm__("halt\n")

#else

#define NIRVANAP_halt()  asm("halt\n")

#endif

// ----------------------------------------------------------------
// Instantly draw tile (16x16 pixels) at specified position
//
// Parameters:
//     tile: tile index (0-255)
//     lin: pixel line (0-200, even values only)
//     col: char column (0-30)
//
// WARNING: If this routine is under execution when interrupt
//          occurs, program may crash!!! (see NIRVANAP_halt)
// ----------------------------------------------------------------

__DPROTO(void,,NIRVANAP_drawT,unsigned int tile, unsigned int lin, unsigned int col)

// ----------------------------------------------------------------
// Instantly change the attributes in a tile area (16x16 pixels) to
// the specified value (use the same INK and PAPER values to "erase"
// a tile)
//
// Parameters:
//     attr: attribute value (0-255), INK+8*PAPER+64*BRIGHT+128*FLASH
//     lin: pixel line (0-200, even values only)
//     col: char column (0-30)
//
// WARNING: If this routine is under execution when interrupt
//          occurs, program may crash!!! (see NIRVANAhalt)
// ----------------------------------------------------------------

__DPROTO(void,,NIRVANAP_fillT,unsigned int attr, unsigned int lin, unsigned int col)

// ----------------------------------------------------------------
// Instantly print a 8x8 character at specified position, afterwards
// paint it with a provided sequence of 4 attribute values.
//
// Parameters:
//     ch: character code (0-255)
//     attrs: attributes address
//     lin: pixel line (16-192, even values only)
//     col: char column (0-31)
// ----------------------------------------------------------------

__DPROTO(void,,NIRVANAP_printC,unsigned int ch, unsigned char *attrs, unsigned int lin, unsigned int col)

// ----------------------------------------------------------------
// Instantly paint a 8x8 character at specified position with a
// provided sequence of 4 attribute values.
//
// Parameters:
//     attrs: attributes address
//     lin: pixel line (16-192, even values only)
//     col: char column (0-31)
// ----------------------------------------------------------------

__DPROTO(void,,NIRVANAP_paintC,unsigned char *attrs, unsigned int lin, unsigned int col)

// ----------------------------------------------------------------
// Instantly change attributes in 8x8 character area to the
// specified value (use the same INK and PAPER values to "erase" a
// character).
//
// Parameters:
//     attr: attribute value (0-255), INK+8*PAPER+64*BRIGHT+128*FLASH
//     lin: pixel line (16-192, even values only)
//     col: char column (0-31)
// ----------------------------------------------------------------

__DPROTO(void,,NIRVANAP_fillC,unsigned int attr, unsigned int lin, unsigned int col)

// ----------------------------------------------------------------
// Update sprite information, so the specified tile will automatically
// appear at the specified location when the next interrupt occurs
// (and automatically redrawn at every interrupt afterwards, until
// this sprite information is updated again).
//
// Sprites are displayed in increasing priority order, i.e.
// sprite 7 will appear in front of everything else.
//
// Notice there's no way to disable sprites. If you don't want to
// display a certain sprite, simply move it to line zero, so it
// will be hidden outside the screen.
//
// Parameters:
//     sprite: sprite number (0-7)
//     tile: tile index (0-255)
//     lin: pixel line (0-200, even values only)
//     col: char column (0-30)
//
// WARNING: If this routine is under execution when interrupt occurs,
//          a sprite (containing partially updated information) may
//          be displayed at an incorrect location on screen (see
//          NIRVANAhalt)
// ----------------------------------------------------------------

__DPROTO(void,,NIRVANAP_spriteT,unsigned int sprite, unsigned int tile, unsigned int lin, unsigned int col)

// ----------------------------------------------------------------
// Instantly draw wide tile (24x16 pixels) at specified position
//
// Parameters:
//     tile: wide tile index (0-255)
//     lin: pixel line (0-200, even values only)
//     col: char column (0-29)
//
// WARNING: If this routine is under execution when interrupt
//          occurs, program may crash!!! (see NIRVANAhalt)
//
// WARNING: Only use this routine if NIRVANA_drawW was enabled!!!
// ----------------------------------------------------------------

__DPROTO(void,,NIRVANAP_drawW,unsigned int tile, unsigned int lin, unsigned int col)

// ----------------------------------------------------------------
// Reconfigure NIRVANA ENGINE to read bicolor tiles (16x16 pixels)
// from another address (default value is 48000).
//
// Parameters:
//     addr: New tile images address
// ----------------------------------------------------------------

__DPROTO(void,,NIRVANAP_tiles,unsigned char *addr)

// ----------------------------------------------------------------
// Reconfigure NIRVANA ENGINE to read wide bicolor tiles (24x16 
// pixels) from another address (default value is 54000).
//
// Parameters:
//     addr: New wide tile images address
//
// WARNING: Only use this routine if NIRVANAP_drawW was enabled!!!
// ----------------------------------------------------------------

__DPROTO(void,,NIRVANAP_wides,unsigned char *addr)

// ----------------------------------------------------------------
// Reconfigure NIRVANA ENGINE to read character table from another
// address (default value is 15360 that corresponds to the standard
// ROM character table).
//
// Parameters:
//     addr: New character table address
// ----------------------------------------------------------------

__DPROTO(void,,NIRVANAP_chars,unsigned char *addr)

// ----------------------------------------------------------------
// Advanced conversions
// ----------------------------------------------------------------

#define ROW2LIN(row)            (((row)+1)<<3)
#define LIN2ROW_UP(lin)         (((lin)>>3)-1)
#define LIN2ROW_DOWN(lin)       (((lin)-1)>>3)

#define SPRITECOL(sprite)       ((unsigned char *)56469+((sprite)<<3))
#define SPRITELIN(sprite)       ((unsigned char *)56470+((sprite)<<3))
#define SPRITEVAL(sprite)       ((unsigned char *)56472+((sprite)<<3))

#endif
