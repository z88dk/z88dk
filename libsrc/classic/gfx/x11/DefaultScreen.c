/*
	Minimal Xlib port
	Stefano Bodrato, 6/3/2007
	
	$Id: DefaultScreen.c,v 1.1 2014-04-16 06:16:16 stefano Exp $
*/

#define _BUILDING_X
#include <X11/Xlib.h>


int DefaultScreen(Display *display) {
	return 1;
}
