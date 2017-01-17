/*
	Minimal Xlib port
	Stefano Bodrato, 15/3/2007
	
	$Id: XNextEvent.c,v 1.1 2014-04-16 06:16:37 stefano Exp $
*/

#define _BUILDING_X
#include <X11/Xlib.h>

#include <stdio.h>

void XNextEvent(Display *display, int *event) {

	if (_x_must_expose == 1)
	{
		_x_must_expose = 0;
		*event = Expose;
		return;
	}

	if (getk() != 0)
		*event = KeyPress;

}
