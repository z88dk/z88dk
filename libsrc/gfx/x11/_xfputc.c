/*
	Minimal Xlib port - Internal functions
	Proportional printing
	Stefano Bodrato, 5/3/2007
	
	$Id: _xfputc.c,v 1.1 2007-12-21 08:04:23 stefano Exp $
*/

#define _BUILDING_X
#include <X11/Xlib.h>

#include <graphics.h>


void _xfputc (char c, char *font, Bool bold)
{


    if (c==12) {
	clg();
	_x_proportional = _y_proportional = 0;
	return;
    }

    if (c==13) {
	_x_proportional = 0;
	//_y_proportional += 8; // compact
	_y_proportional += 9; // normal line spacing
	return;
    }
    if ((_xchar_proportional = _xfindchar( (char) (c - 32), (char *) font)) == -1) return;

    if (_x_proportional + _xchar_proportional[0] >= DisplayWidth(0, 0)) _xfputc (13, font, bold);

    putsprite (SPR_OR, _x_proportional, _y_proportional, _xchar_proportional);
    if (bold) putsprite (SPR_OR, ++_x_proportional, _y_proportional, _xchar_proportional);

    _x_proportional += _xchar_proportional[0];

}

