/*
	Minimal Xlib port
	Stefano Bodrato, 15/3/2007
	
	$Id: xnextevent.c,v 1.1 2007-12-21 08:04:24 stefano Exp $
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
