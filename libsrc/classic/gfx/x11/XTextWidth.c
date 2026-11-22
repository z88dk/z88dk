/*
	Minimal Xlib port
	Stefano Bodrato, 5/3/2007
	
	$Id: XTextWidth.c,v 1.1 2014-04-16 06:16:40 stefano Exp $
*/

#ifdef _DEBUG_
  #include <stdio.h>
#endif

#define _BUILDING_X
#include <X11/Xlib.h>


int XTextWidth(XFontStruct *font_struct, char *string, int count) {

#ifdef _DEBUG_
  printf (" Using font %u  -  ",font_struct->fid);
#endif

	_X_int2=0;
	for (_X_int1=0; _X_int1<count; _X_int1++) {
		if ((_xchar_proportional = (char *) _xfindchar( string[_X_int1] - 32, font_struct->fid)) != -1)
			_X_int2 = _X_int2 + _xchar_proportional[0];
	}
	return _X_int2;
}

