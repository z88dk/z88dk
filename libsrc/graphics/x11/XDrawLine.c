/*
	Minimal Xlib port
	Stefano Bodrato, 5/3/2007
	
	$Id: XDrawLine.c,v 1.1 2014-04-16 06:16:32 stefano Exp $
*/

#define _BUILDING_X
#include <X11/Xlib.h>
#include <graphics.h>

void XDrawLine(Display *display, Drawable win, GC gc, int x1, int y1, int x2, int y2) {
	struct _XWIN *mywin;
	mywin = (char *) win;

	draw(mywin->a_x+x1,mywin->a_y+y1,mywin->a_x+x2,mywin->a_y+y2);
}
