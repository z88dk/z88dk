/*
	Minimal Xlib port
	Stefano Bodrato, 6/3/2007
	
	$Id: defaultscreen.c,v 1.1 2007-12-21 08:04:23 stefano Exp $
*/

#define _BUILDING_X
#include <X11/Xlib.h>


int DefaultScreen(Display *display) {
	return 1;
}
