/*
	Minimal Xlib port
	Stefano Bodrato, 5/3/2007
	
	$Id: XUnloadFont.c,v 1.1 2014-04-16 06:16:41 stefano Exp $
*/

#define _BUILDING_X
#include <X11/Xlib.h>
#include <malloc.h>


void XUnloadFont(Display *display, Font font) {
	//free(font);
}
