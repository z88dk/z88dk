	INCLUDE	"grafix.inc"
	XLIB	setxy

	XREF	COORDS


; ******************************************************************
;
; Move current	pixel coordinate to	(x0,y0). Only legal	coordinates
; are accepted.
;
; Design & programming by Gunther Strube, Copyright (C) InterLogic 1995
;
; X-range	is always	legal (0-255).	Y-range must be 0 -	63.
;
; in:  hl	= (x,y) coordinate
;
; registers changed	after return:
;  ..bcdehl/ixiy same
;  af....../.... different
;
.setxy			ld	a,l
				cp	maxy
				ret	nc				; out of range...
				ld	(COORDS),hl
				ret
