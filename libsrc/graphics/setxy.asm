	INCLUDE	"graphics/grafix.inc"
	XLIB	setxy

	XREF	COORDS

;
;	$Id: setxy.asm,v 1.3 2001-04-18 13:21:37 stefano Exp $
;

; ******************************************************************
;
; Move current pixel coordinate to (x0,y0). Only legal coordinates
; are accepted.
;
; Design & programming by Gunther Strube, Copyright (C) InterLogic 1995
;
; X-range is always legal (0-255). Y-range must be 0 - 63.
;
; in:  hl	= (x,y) coordinate
;
; registers changed	after return:
;  ..bcdehl/ixiy same
;  af....../.... different
;
.setxy
		IF maxx <> 256
			ld	a,h
			cp	maxx
			ret	nc
		ENDIF
			ld	a,l
			cp	maxy
			ret	nc			; out of range...
			ld	(COORDS),hl
			ret
