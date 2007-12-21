/*
	Minimal Xlib port
	Stefano Bodrato, 5/3/2007
	
	$Id: xdrawpoint.c,v 1.1 2007-12-21 08:04:24 stefano Exp $
*/

#define _BUILDING_X
#include <X11/Xlib.h>
#include <graphics.h>

void XDrawPoint(Display *display, Drawable win, GC gc, int x, int y) {
	struct _XWIN *mywin;
	mywin = (char *) win;

	plot(mywin->a_x+x,mywin->a_y+y);
}
