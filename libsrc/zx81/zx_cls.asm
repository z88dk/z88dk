;
;	ZX81 libraries - Stefano
;
;--------------------------------------------------------------
;
;	$Id: zx_cls.asm,v 1.2 2011-11-23 09:03:07 stefano Exp $
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

	ld	hl,(16396)	; D_FILE
    ld  ($400E),hl	; DF_CC ..current ZX81 cursor position on display file

	ld  l,0
	jp	filltxt
