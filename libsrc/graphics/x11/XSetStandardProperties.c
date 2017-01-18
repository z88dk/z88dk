/*
	Minimal Xlib port
	Stefano Bodrato, 14/3/2007
	
	$Id: XSetStandardProperties.c,v 1.1 2014-04-16 06:16:40 stefano Exp $
*/

#define _BUILDING_X
#include <X11/Xlib.h>

#include <stdio.h>


extern char *_Xsmallfont;


void XSetStandardProperties(Display *display, Window win, char *window_name, char *icon_name, char *icon_pixmap, char *argv, int argc, int size_hints) {

	struct _XWIN *mywin;
	
	mywin = (char *) win;
	mywin->title = window_name;
	mywin->icon = icon_pixmap;
	
	_x_proportional = mywin->x + 8;
	_y_proportional = mywin->y + 2;

	for (_X_int1=0; (window_name[_X_int1] != 0 ) && (_x_proportional < (mywin->a_x + mywin->width)); _xfputc(window_name[_X_int1++], &_Xsmallfont, True));

	if (icon_pixmap != NULL)
	{
		//Limit icon size
		if (icon_pixmap[1]>9) icon_pixmap[1]=9;

		// We suppose we have a small icon (16x16)
		putsprite (SPR_OR, mywin->x + mywin->width - 2 - icon_pixmap[0], mywin->y, icon_pixmap);
	}

}
