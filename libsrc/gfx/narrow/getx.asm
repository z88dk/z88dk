
	INCLUDE	"graphics/grafix.inc"
        SECTION code_graphics
		
	PUBLIC	getx
	PUBLIC	_getx

	EXTERN	__gfx_coords

;
;	$Id: getx.asm $
;

; ******************************************************************
;
; Get the current X coordinate of the graphics cursor.
;
;

.getx
._getx

	ld	de,(__gfx_coords)
	ld	h,0
	ld	l,d
	ret
