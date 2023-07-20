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
__ZPROTO2(void,,fill,int,x,int,y)

/* Plot a pixel to screen */
__ZPROTO2(void,,plot,int,x,int,y)
#ifndef __STDC_ABI_ONLY
extern void __LIB__ plot_callee(int x, int y) __smallc __z88dk_callee;
#define plot(a,b)           plot_callee(a,b)
#endif

/* Unplot a pixel */
__ZPROTO2(void,,unplot,int,x,int,y)
#ifndef __STDC_ABI_ONLY
extern void __LIB__ unplot_callee(int x, int y) __smallc __z88dk_callee;
#define unplot(a,b)           unplot_callee(a,b)
#endif

/* XORs a pixel on screen */
__ZPROTO2(void,,xorplot,int,x,int,y)
#ifndef __STDC_ABI_ONLY
extern void __LIB__ xorplot_callee(int x, int y) __smallc __z88dk_callee;
#define xorplot(a,b)           xorplot_callee(a,b)
#endif


/* Get pixel status */
__ZPROTO2(void,,point,int,x,int,y)
#ifndef __STDC_ABI_ONLY
extern bool_t __LIB__ point_callee(int x, int y) __smallc __z88dk_callee;
#define point(a,b)           point_callee(a,b)
#endif

/* Get horizontal or vertical pixel bar, up to 16 pixel long */
__ZPROTO4(int,,multipoint,int,hv,int,length,int,x,int,y)
#ifndef __STDC_ABI_ONLY
extern int __LIB__ multipoint_callee(int hv, int length, int x, int y) __smallc __z88dk_callee;
#define multipoint(a,b,c,d)           multipoint_callee(a,b,c,d)
#endif


/* Draw a line */
__ZPROTO4(void,,draw,int,x1,int,y1,int,x2,int,y2)
#ifndef __STDC_ABI_ONLY
#if !__GBZ80__ && !__8080__
extern void __LIB__ draw_callee(int x1, int y1, int x2, int y2) __smallc __z88dk_callee;
#define draw(a,b,c,d)           draw_callee(a,b,c,d)
#endif
#endif

/* Draw a line in 'XOR' mode */
__ZPROTO4(void,,xordraw,int,x1,int,y1,int,x2,int,y2)
#ifndef __STDC_ABI_ONLY
#if !__GBZ80__ && !__8080__
extern void __LIB__ xordraw_callee(int x1, int y1, int x2, int y2) __smallc __z88dk_callee;
#define xordraw(a,b,c,d)           xordraw_callee(a,b,c,d)
#endif
#endif

/* Remove a line */
__ZPROTO4(void,,undraw,int,x1,int,y1,int,x2,int,y2)
#ifndef __STDC_ABI_ONLY
#if !__GBZ80__ && !__8080__
extern void __LIB__ undraw_callee(int x1, int y1, int x2, int y2) __smallc __z88dk_callee;
#define undraw(a,b,c,d)           undraw_callee(a,b,c,d)
#endif
#endif

/* Relative draw */
__ZPROTO2(void,,drawr,int,px,int,py)
#ifndef __STDC_ABI_ONLY
#if !__GBZ80__ && !__8080__
extern void __LIB__ drawr_callee(int px, int py) __smallc __z88dk_callee;
#define drawr(a,b)           drawr_callee(a,b)
#endif
#endif

/* Relative draw in XOR mode*/
__ZPROTO2(void,,xordrawr,int,px,int,py)
#ifndef __STDC_ABI_ONLY
#if !__GBZ80__ && !__8080__
extern void __LIB__ xordrawr_callee(int px, int py) __smallc __z88dk_callee;
#define xordrawr(a,b)           xordrawr_callee(a,b)
#endif
#endif

/* Remove a relative draw */
__ZPROTO2(void,,undrawr,int,px,int,py)
#ifndef __STDC_ABI_ONLY
#if !__GBZ80__ && !__8080__
extern void __LIB__ undrawr_callee(int px, int py) __smallc __z88dk_callee;
#define undrawr(a,b)           undrawr_callee(a,b)
#endif
#endif

/* Draw up to a specified point */
__ZPROTO2(void,,drawto,int,x2,int,y2)
#ifndef __STDC_ABI_ONLY
#if !__GBZ80__ && !__8080__
extern void __LIB__ drawto_callee(int x2, int y2) __smallc __z88dk_callee;
#define drawto(a,b)           drawto_callee(a,b)
#endif
#endif

/* Draw up to a specified point in XOR mode*/
__ZPROTO2(void,,xordrawto,int,x2,int,y2)
#ifndef __STDC_ABI_ONLY
#if !__GBZ80__ && !__8080__
extern void __LIB__ xordrawto_callee(int x2, int y2) __smallc __z88dk_callee;
#define xordrawto(a,b)           xordrawto_callee(a,b)
#endif
#endif

/* Undraw up to a specified point */
__ZPROTO2(void,,undrawto,int,x2,int,y2)
#ifndef __STDC_ABI_ONLY
#if !__GBZ80__ && !__8080__
extern void __LIB__ undrawto_callee(int x2, int y2) __smallc __z88dk_callee;
#define undrawto(a,b)           undrawto_callee(a,b)
#endif
#endif


/* Pen up for 'move' */
extern void __LIB__ pen_up(void);

/* Pen down for 'move' */
extern void __LIB__ pen_down(void);

/* Relative draw (keeping pen up or down) */
__ZPROTO2(void,,move,int,px,int,py)

/* Set absolute position of graphics cursor */
__ZPROTO2(void,,setpos,int,x,int,y)
#ifndef __STDC_ABI_ONLY
extern void __LIB__ setpos_callee(int px, int py) __smallc __z88dk_callee;
#define setpos(a,b)           setpos_callee(a,b)
#endif

/* Get current X position of graphics cursor */
extern int __LIB__ getx(void);
extern int __LIB__ gety(void);

/* Draw a box (minimum size: 3x3) */
__ZPROTO4(void,,drawb,int,tlx,int,tly,int,width,int,height)
#ifndef __STDC_ABI_ONLY
extern void __LIB__ drawb_callee(int tlx, int tly, int width, int height) __smallc __z88dk_callee;
#define drawb(a,b,c,d)           drawb_callee(a,b,c,d)
#endif

/* Draw a box in XOR mode (minimum size: 3x3) */
__ZPROTO4(void,,xordrawb,int,tlx,int,tly,int,width,int,height)
#ifndef __STDC_ABI_ONLY
extern void __LIB__ xordrawb_callee(int tlx, int tly, int width, int height) __smallc __z88dk_callee;
#define xordrawb(a,b,c,d)           xordrawb_callee(a,b,c,d)
#endif

/* Undraw a box (minimum size: 3x3) */
__ZPROTO4(void,,undrawtodrawb,int,tlx,int,tly,int,width,int,height)
#ifndef __STDC_ABI_ONLY
extern void __LIB__ undrawb_callee(int tlx, int tly, int width, int height) __smallc __z88dk_callee;
#define undrawb(a,b,c,d)           undrawb_callee(a,b,c,d)
#endif

/* Draw a dotted border */
__ZPROTO4(void,,xorborder,int,tlx,int,yly,int,width,int,height)
#ifndef __STDC_ABI_ONLY
extern void __LIB__ xorborder_callee(int tlx, int tly, int width, int height) __smallc __z88dk_callee;
#define xorborder(a,b,c,d)           xorborder_callee(a,b,c,d)
#endif


/* Draw a circle */
__ZPROTO4(void,,circle,int,x,int,y,int,radius,int,skip)
#ifndef __STDC_ABI_ONLY
#if !__GBZ80__ && !__8080__
extern void __LIB__ circle_callee(int x, int y, int radius, int skip) __smallc __z88dk_callee;
#define circle(a,b,c,d)           circle_callee(a,b,c,d)
#endif
#endif

/* Undraw a circle */
__ZPROTO4(void,,uncircle,int,x,int,y,int,radius,int,skip)
#ifndef __STDC_ABI_ONLY
#if !__GBZ80__ && !__8080__
extern void __LIB__ uncircle_callee(int x, int y, int radius, int skip) __smallc __z88dk_callee;
#define uncircle(a,b,c,d)           uncircle_callee(a,b,c,d)
#endif
#endif

/* Draw a circle in XOR mode */
__ZPROTO4(void,,xorcircle,int,x,int,y,int,radius,int,skip)
#ifndef __STDC_ABI_ONLY
#if !__GBZ80__ && !__8080__
extern void __LIB__ xorcircle_callee(int x, int y, int radius, int skip) __smallc __z88dk_callee;
#define xorcircle(a,b,c,d)           xorcircle_callee(a,b,c,d)
#endif
#endif

/* Init GFX mode and clear map */
extern void __LIB__ clg(void);


/* Clear area of graphics map */
__ZPROTO4(void,,clga,int,tlx,int,tly,int,tlx2,int,tly2)
#ifndef __STDC_ABI_ONLY
extern void __LIB__ clga_callee(int tlx, int tly, int tlx2, int tly2) __smallc __z88dk_callee;
#define clga(a,b,c,d)           clga_callee(a,b,c,d)
#endif

/* Invert an area in the graphics map */
__ZPROTO4(void,,xorclga,int,tlx,int,tly,int,tlx2,int,tly2)
#ifndef __STDC_ABI_ONLY
extern void __LIB__ xorclga_callee(int tlx, int tly, int tlx2, int tly2) __smallc __z88dk_callee;
#define xorclga(a,b,c,d)           xorclga_callee(a,b,c,d)
#endif

/* Draw a filled box in the graphics map */
__ZPROTO4(void,,fillb,int,tlx,int,tly,int,width,int,height)
#ifndef __STDC_ABI_ONLY
extern void __LIB__ fillb_callee(int tlx, int tly, int width, int height) __smallc __z88dk_callee;
#define fillb(a,b,c,d)           fillb_callee(a,b,c,d)
#endif


/* pseudo text console support, 4x6 font */
/* when used to replace fputc_cons: -pragma-redirect=fputc_cons=putc4x6 */
extern int __LIB__ putc4x6(char c);
extern int x_4x6;
extern int y_4x6;

/* Get MAX x and y coordinates */
extern int __LIB__ getmaxx(void);
extern int __LIB__ getmaxy(void);

/* Set FATPIX mode.
 *
 * Some targets have rectangular pixels in hires mode (eg SAM Coupe), setting
 * fatpix doubles the width of pixels to make them "square"
 */
extern void __LIB__ gfx_set_fatpix(int enable);

/*
 * Some graphics library need a signal to redraw the screen. Call this 
 * function periodically.
 *
 * At present, this is only needed for the ReGIS driver
 */
extern void __LIB__ gfx_refresh(void);

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
__ZPROTO2(void,,c_plot,int,x,int,y)
/* Unplot a pixel */
__ZPROTO2(void,,c_unplot,int,x,int,y)
/* XORs a pixel on screen */
__ZPROTO2(void,,c_xorplot,int,x,int,y)
/* Get pixel status */
__ZPROTO2(void,,c_point,int,x,int,y)


/* Colour graphics, only few targets are supported */
/* ZX Spectrum has its own implementation aside */
/* Init GFX mode and clear map */
extern void __LIB__ cclg(void) __smallc;

/* Plot a pixel to screen */
__ZPROTO3(void,,cplot,int,x,int,y,int,c)
#ifndef __STDC_ABI_ONLY
extern void __LIB__    cplot_callee(int x, int y, int c) __smallc __z88dk_callee;
#define cplot(a,b,c)           cplot_callee(a,b,c)
#endif

/* Get a pixel from screen */
__ZPROTO2(int,,cpoint,int,x,int,y)
#ifndef __STDC_ABI_ONLY
extern int __LIB__    cpoint_callee(int x, int y) __smallc __z88dk_callee;
#define cpoint(a,b)            cpoint_callee(a,b)
#endif


#endif

