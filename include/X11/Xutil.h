/* $Id: Xutil.h,v 1.1 2008-03-17 14:29:45 stefano Exp $ */

#ifndef _XUTIL_H_
#define _XUTIL_H_

/* You must include <X11/Xlib.h> before including this file */
#include <X11/Xlib.h>

typedef struct {
    	long flags;	/* marks which fields in this structure are defined */
	int x, y;		/* obsolete for new window mgrs, but clients */
	int width, height;	/* should set so old wm's don't mess up */
	int min_width, min_height;
	int max_width, max_height;
    	int width_inc, height_inc;
	struct {
		int x;	/* numerator */
		int y;	/* denominator */
	} min_aspect, max_aspect;
	int base_width, base_height;		/* added by ICCCM version 1 */
	int win_gravity;			/* added by ICCCM version 1 */
} XSizeHints;

/*
 * The next block of definitions are for window manager properties that
 * clients and applications use for communication.
 */

/* flags argument in size hints */
#define USPosition	1 /* user specified x, y */
#define USSize		2 /* user specified width, height */

#define PPosition	4 /* program specified position */
#define PSize		8 /* program specified size */
#define PMinSize	16 /* program specified minimum size */
#define PMaxSize	32 /* program specified maximum size */
#define PResizeInc	64 /* program specified resize increments */
#define PAspect		128 /* program specified min and max aspect ratios */
#define PBaseSize	256 /* program specified base for incrementing */
#define PWinGravity	512 /* program specified window gravity */



#endif /* XUTIL_H */
