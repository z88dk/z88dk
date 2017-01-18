/*
	Minimal Xlib port
	Stefano Bodrato, 5/3/2007
	
	$Id: XDisplayName.c,v 1.1 2014-04-16 06:16:31 stefano Exp $
*/

#define _BUILDING_X
#include <X11/Xlib.h>

char *XDisplayName(char *display_name) {
	return ("127.0.0.1:0.0");
}
