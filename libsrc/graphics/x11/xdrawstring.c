/*
	Minimal Xlib port
	
	void XDrawString(int display, Drawable win, int gc, int x, int y, char *text, int textlen)

	Stefano Bodrato, 5/3/2007
	
	$Id: xdrawstring.c,v 1.1 2007-12-21 08:04:24 stefano Exp $
*/

#define _BUILDING_X
#include <X11/Xlib.h>

#ifdef _DEBUG_
#include <stdio.h>
#endif

void XDrawString(Display *display, Drawable win, GC *gc, int x, int y, char *text, int textlen) {

	struct _XWIN *mywin;
	mywin = (char *) win;

// ======= I have absolutely no idea on why this is necessary ! =======
	gc = *gc;
// ====================================================================

#ifdef _DEBUG_
	printf (" Drawstring; pick in gc: %u   ...  ", gc);
	printf ("  Font ptr: %u  ", gc->values.font);
#endif


	_x_proportional = mywin->a_x + x;  _y_proportional = mywin->a_y + y;
	for (_X_int1=0; _X_int1<textlen; _xfputc(text[_X_int1++], gc->values.font, False));
}

