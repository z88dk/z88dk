/*
	Minimal Xlib port
	Stefano Bodrato, 5/3/2007
	
	$Id: XCheckTypedEvent.c,v 1.1 2014-04-16 06:16:23 stefano Exp $
*/

#define _BUILDING_X
#include <X11/Xlib.h>

int XCheckTypedEvent(Display *display, int type, int event) {
	return 0;
}
