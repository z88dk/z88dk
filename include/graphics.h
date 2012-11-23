/*
 *      Graphics Routines
 *
 *      Since no one actually used these routines I've taken it upon
 *      myself to rewrite the entry conditions so that they are actually
 *      useful and easy to use (hurrah!)
 *
 *      djm 12/4/2000
 *
 *      Stefano has converted many of these routines to the new ports
 *      Some will work, some will not. djm 6/6/2000
 *
 *	$Id: graphics.h,v 1.13 2012-11-23 17:13:50 stefano Exp $
 */

#ifndef __GFX_H__
#define __GFX_H__

#include <sys/compiler.h>


/* Structure to use when opening a window - as per usual, if graph <> 0
 * then open graphics window number with width (pixels) width 
 */

struct window {
        char    number;
        char    x;
        char    y;
        char    width;
        char    depth;
        char    type;
        char    graph;
} ;


/* Fills an area */
extern __LIB__ fill(int x, int y) __SMALLCDECL;
/* Plot a pixel to screen */
extern __LIB__ plot(int x, int y) __SMALLCDECL;
/* Unplot a pixel */
extern __LIB__ unplot(int x, int y) __SMALLCDECL;
/* XORs a pixel on screen */
extern __LIB__ xorplot(int x, int y) __SMALLCDECL;
/* Get pixel status */
extern __LIB__ point(int x, int y) __SMALLCDECL;
/* Get horizontal or vertical pixel bar, up to 16 pixel long */
extern __LIB__ multipoint(int hv, int length, int x, int y) __SMALLCDECL;
/* Draw a line */
extern __LIB__ draw(int x1, int y1, int x2, int y2) __SMALLCDECL;
/* Remove a line */
extern __LIB__ undraw(int x1, int y1, int x2, int y2) __SMALLCDECL;
/* Relative draw */
extern __LIB__ drawr(int px, int py) __SMALLCDECL;
/* Remove a relative draw */
extern __LIB__ undrawr(int px, int py) __SMALLCDECL;
/* Draw up to a sprcified point */
extern __LIB__ drawto(int x2, int y2) __SMALLCDECL;
/* Undraw up to a sprcified point */
extern __LIB__ undrawto(int x2, int y2) __SMALLCDECL;
/* Draw a box */
extern __LIB__ drawb(int tlx, int tly, int width, int height) __SMALLCDECL;
/* Undraw a box */
extern __LIB__ undrawb(int tlx, int tly, int width, int height) __SMALLCDECL;
/* Draw a dotted border */
extern __LIB__ xorborder(int tlx, int tly, int width, int height) __SMALLCDECL;
/* Draw a circle */
extern __LIB__ circle(int x, int y, int radius, int skip) __SMALLCDECL;
/* Undraw a circle */
extern __LIB__ uncircle(int x, int y, int radius, int skip) __SMALLCDECL;
/* Init GFX mode and clear map */
extern __LIB__ clg(void);
/* Clear area of map */
extern __LIB__ clga(int tlx, int tly, int width, int height) __SMALLCDECL;

/* Get MAX x and y coordinates */
extern int __LIB__ getmaxx(void);
extern int __LIB__ getmaxy(void);

/* The "stencil" object is an evolution of a base concept introduced 
 * by Rafael de Oliveira Jannone in his gfx library: 
 * a convex area is defined by two byte vectors, pointing 
 * respectivelty to the leftmost and the rightmost X coordinates.
 * They're stuffed in a single byte vector, long at least twice the 
 * resolution of the Y axis (getmaxy might be used).
 */
 
/* Set/Reset the couple of vectors being part of a "stencil" */
extern __LIB__ __FASTCALL__ stencil_init(unsigned char *stencil);
/* Add a pixel to a figure defined inside a stencil object */
extern __LIB__ stencil_add_point(int x, int y, unsigned char *stencil) __SMALLCDECL;
/* Trace a relative line into a stencil object (extend shape) */
extern __LIB__ stencil_add_liner(int dx, int dy, unsigned char *stencil) __SMALLCDECL;
/* Trace a line into a stencil object up to a given coordinate (extend shape) */
extern __LIB__ stencil_add_lineto(int x2, int y2, unsigned char *stencil) __SMALLCDECL;
/* Add a side to a figure defined inside a stencil object */
extern __LIB__ stencil_add_side(int x1, int y1, int x2, int y2, unsigned char *stencil) __SMALLCDECL;
/* Add a circular shape to a figure defined inside a stencil object */
extern __LIB__ stencil_add_circle(int x, int y, int radius, int skip, unsigned char *stencil) __SMALLCDECL;
/* Render an area delimited by a stencil object, with the specified dither intensity (0..11) */
extern __LIB__ stencil_render(unsigned char *stencil, unsigned char intensity) __SMALLCDECL;

/* 'Graphic Profiles' are byte streams containing vector and surface descriptions
   they are detailed in <gfxprofile.h> */
extern __LIB__ draw_profile(int dx, int dy, int scale, unsigned char *metapic) __SMALLCDECL;

#ifndef SPECTRUM
/* Open a z88 window..either graphics or text */
extern __LIB__ window(struct window *) __SMALLCDECL;
/* Scroll map left by one pixel */
extern __LIB__ lscroll(int x, int y, int width, int height, int pixels) __SMALLCDECL;
/* Scroll map right by one pixel (unwritten) */
extern __LIB__ rscroll(int x, int y, int width, int height, int pixels) __SMALLCDECL;
/* Close the map */
extern __LIB__ closegfx(struct window *) __SMALLCDECL;

/* Colour graphics, only few targets are supported */
/* ZX Spectrum has its own implementation aside */
/* Init GFX mode and clear map */
extern __LIB__ cclg(void) __SMALLCDECL;
/* Plot a pixel to screen */
extern __LIB__ cplot(int x, int y, int color) __SMALLCDECL;
/* Draw a line */
extern __LIB__ cdraw(int x1, int y1, int x2, int y2, int color) __SMALLCDECL;
/* Draw a circle */
extern __LIB__ ccircle(int x, int y, int radius, int skip, int color) __SMALLCDECL;
/* Relative draw */
extern __LIB__ cdrawr(int px, int py, int color) __SMALLCDECL;
#endif


#endif

