/*
	Minimal Xlib port
	Stefano Bodrato, 6/3/2007
	
	$Id: RootWindow.c,v 1.1 2014-04-16 06:16:21 stefano Exp $
*/

#define _BUILDING_X
#include <X11/Xlib.h>


int RootWindow(Display *display,int screen) {
	return 1;
}
