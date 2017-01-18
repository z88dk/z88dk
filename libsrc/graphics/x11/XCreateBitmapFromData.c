/*
	Minimal Xlib port
	Stefano Bodrato, 5/3/2007
	
	$Id: XCreateBitmapFromData.c,v 1.1 2014-04-16 06:16:30 stefano Exp $
*/

#define _BUILDING_X
#include <X11/Xlib.h>

char _XBitmap[34];	// only space for an icon, for now

Pixmap XCreateBitmapFromData(Display *display, Drawable win, char *bits, int width, int height) {

	char mychar;

	_XBitmap[0]=(char)width;
	_XBitmap[1]=(char)height;
	
	_X_int3 = width>>3;

	for (_X_int1=0; _X_int1<height; _X_int1++) {
		for (_X_int2=0; _X_int2<_X_int3; _X_int2++) {
			_XBitmap[2+(_X_int1*_X_int3)+_X_int2]=_ByteReverse(bits[(_X_int1*_X_int3)+_X_int2]);
		}
	}

	return _XBitmap;
}


int _ByteReverse (int mybyte) {
#asm
	pop	bc
	pop	hl
	push	hl
	push	bc

	ld	b,8
.invloop
	rr	l
	rla
	djnz	invloop
	ld	l,a
	ld	h,0
	ret

#endasm
}

