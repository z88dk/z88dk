/*
	Minimal Xlib port
	Stefano Bodrato, 5/3/2007
	
	$Id: XSelectInput.c,v 1.1 2014-04-16 06:16:38 stefano Exp $
*/

#define _BUILDING_X
#include <X11/Xlib.h>


void XSelectInput(Display *display, Window win, int event_mask) {
}
