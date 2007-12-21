/*
	Minimal Xlib port
	Stefano Bodrato, 5/3/2007
	
	$Id: xopendisplay.c,v 1.1 2007-12-21 08:04:24 stefano Exp $
*/

#define _BUILDING_X
#include <X11/Xlib.h>
#include <graphics.h>

struct _XDisplay*XOpenDisplay(char *display_name) {
	clg();
	return 1;
}
