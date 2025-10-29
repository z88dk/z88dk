/*
	Minimal Xlib port
	Stefano Bodrato, 5/3/2007
	
	$Id: XOpenDisplay.c,v 1.1 2014-04-16 06:16:37 stefano Exp $
*/

#define _BUILDING_X
#include <X11/Xlib.h>
#include <graphics.h>

struct _XDisplay*XOpenDisplay(char *display_name) {
	clg();
	return 1;
}
