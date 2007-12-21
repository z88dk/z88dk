/*
	Minimal Xlib port
	Stefano Bodrato, 6/3/2007
	
	$Id: xsetlineattributes.c,v 1.1 2007-12-21 08:04:24 stefano Exp $
*/

#define _BUILDING_X
#include <X11/Xlib.h>


void XSetLineAttributes(Display *display, GC gc, int line_width, int line_style, int cap_style, int join_style) {
}
