;
;	ZX81 libraries - Stefano
;
;--------------------------------------------------------------
;
;	$Id: zx_cls.asm,v 1.1 2011-11-21 07:37:37 stefano Exp $
;
;----------------------------------------------------------------
;
; Fill text memory with specified character code
;
;----------------------------------------------------------------

	XLIB	zx_cls
	
	LIB		filltxt

	DEFC	COLUMN=$4039    ; S_POSN_x

zx_cls:
	ld  hl,$1821	; (33,24) = top left screen posn
	ld  (COLUMN),hl
	ld  l,0
	jp	filltxt
