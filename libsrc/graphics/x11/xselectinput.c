/*
	Minimal Xlib port
	Stefano Bodrato, 5/3/2007
	
	$Id: xselectinput.c,v 1.1 2007-12-21 08:04:24 stefano Exp $
*/

#define _BUILDING_X
#include <X11/Xlib.h>


void XSelectInput(Display *display, Window win, int event_mask) {
}
