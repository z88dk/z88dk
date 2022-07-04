/*
	Minimal Xlib port - Internal functions
	Proportional printing
	Stefano Bodrato, 5/3/2007
	
	$Id: _xfputc.c $
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

    if ((c==13)||(c==10)) {
	_x_proportional = 0;
	_y_proportional += _yh_proportional; // line spacing, default is 9
	return;
    }
    if ((_xchar_proportional = _xfindchar( (char) (c - 32), (char *) font)) == -1) return;

    if (_x_proportional + _xchar_proportional[0] >= getmaxx()) {
		_x_proportional = 0;
		_y_proportional += _yh_proportional; // line spacing, default is 9
	};

    putsprite (SPR_OR, _x_proportional, _y_proportional, _xchar_proportional);
    if (bold) putsprite (SPR_OR, ++_x_proportional, _y_proportional, _xchar_proportional);

    _x_proportional += _xchar_proportional[0];

}

