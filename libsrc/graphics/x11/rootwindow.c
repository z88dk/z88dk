/*
	Minimal Xlib port
	Stefano Bodrato, 6/3/2007
	
	$Id: rootwindow.c,v 1.1 2007-12-21 08:04:24 stefano Exp $
*/

#define _BUILDING_X
#include <X11/Xlib.h>


int RootWindow(Display *display,int screen) {
	return 1;
}
