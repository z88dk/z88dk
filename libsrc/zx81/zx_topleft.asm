;
;	ZX81 libraries - Stefano
;
;----------------------------------------------------------------
;
;	$Id: zx_topleft.asm,v 1.1 2011-12-01 17:46:45 stefano Exp $
;
;----------------------------------------------------------------
;
; Position the text cursor on top-left
;
;----------------------------------------------------------------

	XLIB   zx_topleft

	DEFC   COLUMN=$4039    ; S_POSN_x

zx_topleft:
	ld  hl,$1821	; (33,24) = top left screen posn
	ld  (COLUMN),hl
	ld	hl,(16396)	; D_FILE
    ld  ($400E),hl	; DF_CC ..position ZX81 cursor at beginning of display file
	ret
