/*
 *	Graphics Routines
 *
 *	Since no one actually used these routines I've taken it upon
 *	myself to rewrite the entry conditions so that they are actually
 *	useful and easy to use (hurrah!)
 *
 *	djm 12/4/2000
 *
 *	Stefano has converted many of these routines to the new ports
 *	Some will work, some will not. djm 6/6/2000
 *
 */

#ifndef _GFX_H
#define _GFX_H



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

/* Plot a pixel to screen */
extern __LIB__ plot(int x, int y);
/* Unplot a pixel */
extern __LIB__ unplot(int x, int y);
/* Get pixel status */
extern __LIB__ point(int x, int y);
/* Draw a line */
extern __LIB__ draw(int x1, int y1, int x2, int y2);
/* Remove a line */
extern __LIB__ undraw(int x1, int y1, int x2, int y2);
/* Relative draw */
extern __LIB__ drawr(int px, int py);
/* Remove a relative draw */
extern __LIB__ undrawr(int px, int py);
/* Draw a box */
extern __LIB__ drawb(int tlx, int tly, int width, int height);
/* Undraw a box */
extern __LIB__ undrawb(int tlx, int tly, int width, int height);
/* Draw a circle */
extern __LIB__ circle(int x, int y, int radius, int skip);
/* Undraw a circle */
extern __LIB__ uncircle(int x, int y, int radius, int skip);
/* Clear map */
extern __LIB__ clg(void);
/* Clear area of map */
extern __LIB__ clga(int tlx, int tly, int width, int height);

#ifndef SPECTRUM
/* Open a z88 window..either graphics or text */
extern __LIB__ window(struct window *);
/* Scroll map left by one pixel */
extern __LIB__ lscroll(int x, int y, int width, int height, int pixels);
/* Scroll map right by one pixel (unwritten) */
extern __LIB__ rscroll(int x, int y, int width, int height, int pixels);
/* Close the map */
extern __LIB__ closegfx(struct window *);
#endif



#endif

