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

/** Old style plot - try plot_point() */
void __LIB__ plot(uint16_t x, uint16_t y, uint16_t colour, uint16_t mode) __smallc;

/** Plot a point in the current drawing mode and colour at (x,y) */
void __LIB__ plot_point(uint16_t x, uint16_t y) __smallc;

/** I (MLH) have no idea what switch_data does... */
void __LIB__ switch_data(uint16_t x, uint16_t y, unsigned char *src, unsigned char *dst) __smallc NONBANKED;

/** Ditto */
void __LIB__ draw_image(unsigned char *data) NONBANKED;

/** Draw a line in the current drawing mode and colour from (x1,y1) to (x2,y2) */
void __LIB__ line(uint16_t x1, uint16_t y1, uint16_t x2, uint16_t y2) __smallc;

/** Draw a box (rectangle) with corners (x1,y1) and (x2,y2) using fill mode
   'style' (one of NOFILL or FILL */
void __LIB__ box(uint16_t x1, uint16_t y1, uint16_t x2, uint16_t y2, uint16_t style) __smallc;

/** Draw a circle with centre at (x,y) and radius 'radius'.  'style' sets
   the fill mode */
void __LIB__	circle(uint16_t x, uint16_t y, uint16_t radius, uint16_t style) __smallc;

/** Returns the current colour of the pixel at (x,y) */
uint16_t __LIB__	getpix(uint16_t x, uint16_t y) __smallc;

/** Prints the character 'chr' in the default font at the current position */
void __LIB__	wrtchr(char chr);

/** Sets the current text position to (x,y).  Note that x and y have units
   of cells (8 pixels) */
void __LIB__ gotogxy(uint16_t x, uint16_t y) __smallc;

/** Set the current foreground colour (for pixels), background colour, and
   draw mode */
void __LIB__ color(uint16_t forecolor, uint16_t backcolor, uint16_t mode) __smallc;

#endif /* __DRAWING_H */
