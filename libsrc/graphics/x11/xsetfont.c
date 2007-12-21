/*
	Minimal Xlib port
	Stefano Bodrato, 5/3/2007
	
	$Id: xsetfont.c,v 1.1 2007-12-21 08:04:24 stefano Exp $
*/

#ifdef _DEBUG_
  #include <stdio.h>
#endif

#define _BUILDING_X
#include <X11/Xlib.h>

void XSetFont(Display *display, GC mygc, Font font) {
	//GC mygc;
	//*mygc=*gc;
	mygc->values.font = font;

#ifdef _DEBUG_
	printf (" Setting font: %u in GC %u  ", font, mygc);
	printf (" Font set: %u    ", mygc->values.font);
#endif

}
