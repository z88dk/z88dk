/*
	Minimal Xlib port
	Stefano Bodrato, 5/3/2007
	
	$Id: xcreategc.c,v 1.1 2007-12-21 08:04:24 stefano Exp $
*/

#ifdef _DEBUG_
  #include <stdio.h>
#endif

#define _BUILDING_X
#include <X11/Xlib.h>

GC Xcommon_mygc;

struct GC *XCreateGC(Display *display, Drawable win, int valuemask, int values) {

#ifdef _DEBUG_
	printf ("  CreateGC: %u   ", Xcommon_mygc);
#endif

	return Xcommon_mygc;
}
/*
GC XCreateGC(display, d, valuemask, values)
      Display *display;
      Drawable d;
      unsigned long valuemask;
      XGCValues *values;
*/
