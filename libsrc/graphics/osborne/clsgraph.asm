	INCLUDE	"graphics/grafix.inc"

                SECTION         code_clib
	PUBLIC	cleargraphics
   PUBLIC   _cleargraphics

	EXTERN	base_graphics

;
;	$Id: clsgraph.asm $
;

; ******************************************************************
;
;	Clear graphics	area, i.e. reset all bits in graphics
;
;
.cleargraphics
._cleargraphics
	ld	e,$1a
	ld	c,2
	call 5
	ld hl,$f000
	ld (hl),32	; hide cursor (overwrite the underscored space character)
	ret

