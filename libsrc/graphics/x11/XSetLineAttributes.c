/*
	Minimal Xlib port
	Stefano Bodrato, 6/3/2007
	
	$Id: XSetLineAttributes.c,v 1.1 2014-04-16 06:16:39 stefano Exp $
*/

#define _BUILDING_X
#include <X11/Xlib.h>


void XSetLineAttributes(Display *display, GC gc, int line_width, int line_style, int cap_style, int join_style) {
}
