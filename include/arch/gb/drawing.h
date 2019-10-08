/** @file gb/drawing.h
    All Points Addressable (APA) mode drawing library.

    Drawing routines originally by Pascal Felber
    Legendary overhall by Jon Fuge <jonny@q-continuum.demon.co.uk>
    Commenting by Michael Hope

    Note that the standard text printf() and putchar() cannot be used
    in APA mode - use gprintf() and wrtchr() instead.
*/
#ifndef __DRAWING_H
#define __DRAWING_H

#include <sys/types.h>
#include <sys/compiler.h>

/** Size of the screen in pixels */
#define GRAPHICS_WIDTH	160
#define GRAPHICS_HEIGHT 144

/** Possible drawing modes */
#if ORIGINAL
	#define	SOLID	0x10		/* Overwrites the existing pixels */
	#define	OR	0x20		/* Performs a logical OR */
	#define	XOR	0x40		/* Performs a logical XOR */
	#define	AND	0x80		/* Performs a logical AND */
#else
	#define	SOLID	0x00		/* Overwrites the existing pixels */
	#define	OR	0x01		/* Performs a logical OR */
	#define	XOR	0x02		/* Performs a logical XOR */
	#define	AND	0x03		/* Performs a logical AND */
#endif

/** Possible drawing colours */
#define	WHITE	0
#define	LTGREY	1
#define	DKGREY	2
#define	BLACK	3

/** Possible fill styles for box() and circle() */
#define	M_NOFILL	0
#define	M_FILL		1

/** Possible values for signed_value in gprintln() and gprintn() */
#define SIGNED   1
#define UNSIGNED 0


/** Print the string 'str' with no interpretation */
void __LIB__ gprint(char *str) NONBANKED;

/** Print the long number 'number' in radix 'radix'.  signed_value should
   be set to SIGNED or UNSIGNED depending on whether the number is signed
   or not */
void __LIB__ gprintln(int16_t number, int8_t radix, int8_t signed_value) __smallc;

/** Print the number 'number' as in 'gprintln' */
void __LIB__	gprintn(int8_t number, int8_t radix, int8_t signed_value) __smallc;

/** Print the formatted string 'fmt' with arguments '...' */
int8_t __LIB__	gprintf(char *fmt,...) NONBANKED;

/** Old style plot - try plot_point() */
void __LIB__ plot(uint8_t x, uint8_t y, uint8_t colour, uint8_t mode) __smallc;

/** Plot a point in the current drawing mode and colour at (x,y) */
void __LIB__ plot_point(uint8_t x, uint8_t y) __smallc;

/** I (MLH) have no idea what switch_data does... */
void __LIB__ switch_data(uint8_t x, uint8_t y, unsigned char *src, unsigned char *dst) __smallc NONBANKED;

/** Ditto */
void __LIB__ draw_image(unsigned char *data) NONBANKED;

/** Draw a line in the current drawing mode and colour from (x1,y1) to (x2,y2) */
void __LIB__ line(uint8_t x1, uint8_t y1, uint8_t x2, uint8_t y2) __smallc;

/** Draw a box (rectangle) with corners (x1,y1) and (x2,y2) using fill mode
   'style' (one of NOFILL or FILL */
void __LIB__ box(uint8_t x1, uint8_t y1, uint8_t x2, uint8_t y2, uint8_t style) __smallc;

/** Draw a circle with centre at (x,y) and radius 'radius'.  'style' sets
   the fill mode */
void __LIB__	circle(uint8_t x, uint8_t y, uint8_t radius, uint8_t style) __smallc;

/** Returns the current colour of the pixel at (x,y) */
uint8_t __LIB__	getpix(uint8_t x, uint8_t y) __smallc;

/** Prints the character 'chr' in the default font at the current position */
void __LIB__	wrtchr(char chr);

/** Sets the current text position to (x,y).  Note that x and y have units
   of cells (8 pixels) */
void __LIB__ gotogxy(uint8_t x, uint8_t y) __smallc;

/** Set the current foreground colour (for pixels), background colour, and
   draw mode */
void __LIB__ color(uint8_t forecolor, uint8_t backcolor, uint8_t mode) __smallc;

#endif /* __DRAWING_H */
