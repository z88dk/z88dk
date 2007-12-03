/*
 * Headerfile for MSX specific stuff
 *
 * $Id: msx.h,v 1.2 2007-12-03 07:51:33 stefano Exp $
 */

#ifndef __MSX_H__
#define __MSX_H__

#include <sys/types.h>


// Check if MSX 1 or MSX 2
extern int __LIB__ msx_type();

// Detect the VRAM size (in KB)
extern int __LIB__ msx_vram();

// Set the screen mode
extern void __LIB__ __FASTCALL__ msx_screen(int mode);

// VRAM read
extern int __LIB__ __FASTCALL__ msx_vpeek(int address);

// VRAM write
extern void __LIB__ msx_vpoke(int address, int value);

// Switch to text mode
extern void __LIB__ msx_text();

// Disable screen
extern void __LIB__ msx_blank();

// Enable screen
extern void __LIB__ msx_noblank();

// Change the MSX color attributes
extern int __LIB__ msx_color(int foreground, int background, int border);

#define TRANSPARENT    0x00
#define BLACK          0x01
#define MEDIUM_GREEN   0x02
#define LIGHT_GREEN    0x03
#define DARK_BLUE      0x04
#define LIGHT_BLUE     0x05
#define DARK_RED       0x06
#define CYAN           0x07
#define MEDIUM_RED     0x08
#define LIGHT_RED      0x09
#define DARK_YELLOW    0x0A
#define LIGHT_YELLOW   0x0B
#define DARK_GREEN     0x0C
#define MAGENTA        0x0D
#define GRAY           0x0E
#define WHITE          0x0F


#endif
