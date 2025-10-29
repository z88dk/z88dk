/*
	Minimal Xlib port
	Stefano Bodrato, 6/3/2007
	
	$Id: DisplayHeight.c,v 1.1 2014-04-16 06:16:19 stefano Exp $
*/

#define _BUILDING_X
#include <X11/Xlib.h>
#include <graphics.h>


int DisplayHeight(Display *display,int screen) {
	return getmaxy();
}

