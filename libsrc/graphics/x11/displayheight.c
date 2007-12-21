/*
	Minimal Xlib port
	Stefano Bodrato, 6/3/2007
	
	$Id: displayheight.c,v 1.1 2007-12-21 08:04:23 stefano Exp $
*/

#define _BUILDING_X
#include <X11/Xlib.h>


int DisplayHeight(Display *display,int screen) {
#asm
	INCLUDE	"../grafix.inc"
	ld	hl,maxy
#endasm
}

