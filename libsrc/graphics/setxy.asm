	INCLUDE	"graphics/grafix.inc"
        SECTION code_clib
	PUBLIC	setxy

	EXTERN	__gfx_coords

;
;	$Id: setxy.asm,v 1.7 2016-07-02 09:01:35 dom Exp $
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
			ld	(__gfx_coords),hl
			ret
