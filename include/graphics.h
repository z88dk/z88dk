/*
 *      Graphics Routines
 *
 *      This file holds the declarations for the generic (multi target) graphics routines.
 *
 *	$Id: graphics.h $
 */

#ifndef __GFX_H__
#define __GFX_H__

#include <sys/compiler.h>
#include <sys/types.h>
#include <stdint.h>

#pragma output graphics


/* Structure to use when opening a window - as per usual, if graph <> 0
 * then open graphics window number with width (pixels) width 
 */

struct window {
        uint8_t number;
        uint8_t x;
        uint8_t y;
        uint8_t width;
        uint8_t depth;
        uint8_t type;
        uint8_t graph;
} ;


/* Fills an area */
extern void __LIB__ fill(int x, int y) __smallc;


/* Plot a pixel to screen */
extern void __LIB__ plot(int x, int y) __smallc;
extern void __LIB__ plot_callee(int x, int y) __smallc __z88dk_callee;
#define plot(a,b)           plot_callee(a,b)

/* Unplot a pixel */
extern void __LIB__ unplot(int x, int y) __smallc;
extern void __LIB__ unplot_callee(int x, int y) __smallc __z88dk_callee;
#define unplot(a,b)           unplot_callee(a,b)

/* XORs a pixel on screen */
extern void __LIB__ xorplot(int x, int y) __smallc;
extern void __LIB__ xorplot_callee(int x, int y) __smallc __z88dk_callee;
#define xorplot(a,b)           xorplot_callee(a,b)


/* Get pixel status */
extern bool_t __LIB__ point(int x, int y) __smallc;
extern bool_t __LIB__ point_callee(int x, int y) __smallc __z88dk_callee;
#define point(a,b)           point_callee(a,b)

/* Get horizontal or vertical pixel bar, up to 16 pixel long */
extern int __LIB__ multipoint(int hv, int length, int x, int y) __smallc;
extern int __LIB__ multipoint_callee(int hv, int length, int x, int y) __smallc __z88dk_callee;
#define multipoint(a,b,c,d)           multipoint_callee(a,b,c,d)


/* Draw a line */
extern void __LIB__ draw(int x1, int y1, int x2, int y2) __smallc;
extern void __LIB__ draw_callee(int x1, int y1, int x2, int y2) __smallc __z88dk_callee;
#define draw(a,b,c,d)           draw_callee(a,b,c,d)

/* Draw a line in 'XOR' mode */
extern void __LIB__ xordraw(int x1, int y1, int x2, int y2) __smallc;
extern void __LIB__ xordraw_callee(int x1, int y1, int x2, int y2) __smallc __z88dk_callee;
#define xordraw(a,b,c,d)           xordraw_callee(a,b,c,d)

/* Remove a line */
extern void __LIB__ undraw(int x1, int y1, int x2, int y2) __smallc;
extern void __LIB__ undraw_callee(int x1, int y1, int x2, int y2) __smallc __z88dk_callee;
#define undraw(a,b,c,d)           undraw_callee(a,b,c,d)

/* Relative draw */
extern void __LIB__ drawr(int px, int py) __smallc;
extern void __LIB__ drawr_callee(int px, int py) __smallc __z88dk_callee;
#define drawr(a,b)           drawr_callee(a,b)

/* Relative draw in XOR mode*/
extern void __LIB__ xordrawr(int px, int py) __smallc;
extern void __LIB__ xordrawr_callee(int px, int py) __smallc __z88dk_callee;
#define xordrawr(a,b)           xordrawr_callee(a,b)

/* Remove a relative draw */
extern void __LIB__ undrawr(int px, int py) __smallc;
extern void __LIB__ undrawr_callee(int px, int py) __smallc __z88dk_callee;
#define undrawr(a,b)           undrawr_callee(a,b)

/* Draw up to a specified point */
extern void __LIB__ drawto(int x2, int y2) __smallc;
extern void __LIB__ drawto_callee(int x2, int y2) __smallc __z88dk_callee;
#define drawto(a,b)           drawto_callee(a,b)

/* Draw up to a specified point in XOR mode*/
extern void __LIB__ xordrawto(int x2, int y2) __smallc;
extern void __LIB__ xordrawto_callee(int x2, int y2) __smallc __z88dk_callee;
#define xordrawto(a,b)           xordrawto_callee(a,b)

/* Undraw up to a specified point */
extern void __LIB__ undrawto(int x2, int y2) __smallc;
extern void __LIB__ undrawto_callee(int x2, int y2) __smallc __z88dk_callee;
#define undrawto(a,b)           undrawto_callee(a,b)


/* Pen up for 'move' */
extern void __LIB__ pen_up(void);

/* Pen down for 'move' */
extern void __LIB__ pen_down(void);

/* Relative draw (keeping pen up or down) */
extern void __LIB__ move(int px, int py) __smallc;

/* Set absolute position of graphics cursor */
extern void __LIB__ setpos(int x, int y) __smallc;
extern void __LIB__ setpos_callee(int px, int py) __smallc __z88dk_callee;
#define setpos(a,b)           setpos_callee(a,b)

/* Get current X position of graphics cursor */
extern int __LIB__ getx();
extern int __LIB__ gety();

/* Draw a box (minimum size: 3x3) */
extern void __LIB__ drawb(int tlx, int tly, int width, int height) __smallc;
extern void __LIB__ drawb_callee(int tlx, int tly, int width, int height) __smallc __z88dk_callee;
#define drawb(a,b,c,d)           drawb_callee(a,b,c,d)

/* Draw a box in XOR mode (minimum size: 3x3) */
extern void __LIB__ xordrawb(int tlx, int tly, int width, int height) __smallc;
extern void __LIB__ xordrawb_callee(int tlx, int tly, int width, int height) __smallc __z88dk_callee;
#define xordrawb(a,b,c,d)           xordrawb_callee(a,b,c,d)

/* Undraw a box (minimum size: 3x3) */
extern void __LIB__ undrawb(int tlx, int tly, int width, int height) __smallc;
extern void __LIB__ undrawb_callee(int tlx, int tly, int width, int height) __smallc __z88dk_callee;
#define undrawb(a,b,c,d)           undrawb_callee(a,b,c,d)

/* Draw a dotted border */
extern void __LIB__ xorborder(int tlx, int tly, int width, int height) __smallc;
extern void __LIB__ xorborder_callee(int tlx, int tly, int width, int height) __smallc __z88dk_callee;
#define xorborder(a,b,c,d)           xorborder_callee(a,b,c,d)


/* Draw a circle */
extern void __LIB__ circle(int x, int y, int radius, int skip) __smallc;
extern void __LIB__ circle_callee(int x, int y, int radius, int skip) __smallc __z88dk_callee;
#define circle(a,b,c,d)           circle_callee(a,b,c,d)

/* Undraw a circle */
extern void __LIB__ uncircle(int x, int y, int radius, int skip) __smallc;
extern void __LIB__ uncircle_callee(int x, int y, int radius, int skip) __smallc __z88dk_callee;
#define uncircle(a,b,c,d)           uncircle_callee(a,b,c,d)

/* Draw a circle in XOR mode */
extern void __LIB__ xorcircle(int x, int y, int radius, int skip) __smallc;
extern void __LIB__ xorcircle_callee(int x, int y, int radius, int skip) __smallc __z88dk_callee;
#define xorcircle(a,b,c,d)           xorcircle_callee(a,b,c,d)

/* Init GFX mode and clear map */
extern void __LIB__ clg(void);

/* Clear area of graphics map */
extern void __LIB__ clga(int tlx, int tly, int width, int height) __smallc;
extern void __LIB__ clga_callee(int tlx, int tly, int width, int height) __smallc __z88dk_callee;
#define clga(a,b,c,d)           clga_callee(a,b,c,d)

/* Invert an area in the graphics map */
extern void __LIB__ xorclga(int tlx, int tly, int width, int height) __smallc;
extern void __LIB__ xorclga_callee(int tlx, int tly, int width, int height) __smallc __z88dk_callee;
#define xorclga(a,b,c,d)           xorclga_callee(a,b,c,d)

/* Draw a filled box in the graphics map */
extern void __LIB__ fillb(int tlx, int tly, int width, int height) __smallc;
extern void __LIB__ fillb_callee(int tlx, int tly, int width, int height) __smallc __z88dk_callee;
#define fillb(a,b,c,d)           fillb_callee(a,b,c,d)


/* pseudo text console support, 4x6 font */
/* when used to replace fputc_cons: -pragma-redirect=fputc_cons=putc4x6 */
extern int __LIB__ putc4x6(char c);
extern int x_4x6;
extern int y_4x6;

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
extern void __LIB__  stencil_init(unsigned char *stencil) __z88dk_fastcall;
/* Add a pixel to a figure defined inside a stencil object */
extern void __LIB__ stencil_add_point(int x, int y, unsigned char *stencil) __smallc;
/* Trace a relative line into a stencil object (extend shape) */
extern void __LIB__ stencil_add_liner(int dx, int dy, unsigned char *stencil) __smallc;
/* Trace a line into a stencil object up to a given coordinate (extend shape) */
extern void __LIB__ stencil_add_lineto(int x2, int y2, unsigned char *stencil) __smallc;
/* Add a side to a figure defined inside a stencil object */
extern void __LIB__ stencil_add_side(int x1, int y1, int x2, int y2, unsigned char *stencil) __smallc;
/* Add a circular shape to a figure defined inside a stencil object */
extern void __LIB__ stencil_add_circle(int x, int y, int radius, int skip, unsigned char *stencil) __smallc;
/* Render an area delimited by a stencil object, with the specified dither intensity (0..11) */
extern void __LIB__ stencil_render(unsigned char *stencil, unsigned char intensity) __smallc;

/* 'Graphic Profiles' are byte streams containing vector and surface descriptions
   they are detailed in <gfxprofile.h> */
extern void __LIB__ draw_profile(int dx, int dy, int scale, unsigned char *metapic) __smallc;

#ifdef Z88
/* Open a z88 window..either graphics or text */
extern int __LIB__ window(struct window *) __smallc;
/* Scroll map left by one pixel */
extern void __LIB__ lscroll(int x, int y, int width, int height, int pixels) __smallc;
/* Scroll map right by one pixel (unwritten) */
extern void __LIB__ rscroll(int x, int y, int width, int height, int pixels) __smallc;
/* Close the map */
extern void __LIB__ closegfx(struct window *) __smallc;
#endif

/* Chunk 4x4 pixel */
extern void __LIB__ c_plot(int x, int y) __smallc;
/* Unplot a pixel */
extern void __LIB__ c_unplot(int x, int y) __smallc;
/* XORs a pixel on screen */
extern void __LIB__ c_xorplot(int x, int y) __smallc;
/* Get pixel status */
extern int __LIB__ c_point(int x, int y) __smallc;


/* Colour graphics, only few targets are supported */
/* ZX Spectrum has its own implementation aside */
/* Init GFX mode and clear map */
extern void __LIB__ cclg(void) __smallc;

/* Plot a pixel to screen */
extern void __LIB__           cplot(int x, int y, int c) __smallc;
extern void __LIB__    cplot_callee(int x, int y, int c) __smallc __z88dk_callee;
#define cplot(a,b,c)           cplot_callee(a,b,c)

/* Get a pixel from screen */
extern char __LIB__           cpoint(int x, int y) __smallc;
extern char __LIB__    cpoint_callee(int x, int y) __smallc __z88dk_callee;
#define cpoint(a,b)            cpoint_callee(a,b)


#endif

