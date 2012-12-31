;
;	ZX81 libraries - Stefano
;
;----------------------------------------------------------------
;
;	$Id: zx_topleft.asm,v 1.3 2012-12-31 10:38:24 stefano Exp $
;
;----------------------------------------------------------------
;
; Position the text cursor on top-left
;
;----------------------------------------------------------------

	XLIB   zx_topleft

IF FORzx81
	DEFC   COLUMN=$4039    ; S_POSN_x
ELSE
	DEFC   COLUMN=$4024    ; S_POSN_x
ENDIF

zx_topleft:
	ld  hl,$1821	; (33,24) = top left screen posn
	ld  (COLUMN),hl
	ld	hl,(16396)	; D_FILE
IF FORzx81
    ld  ($400E),hl	; DF_CC ..position ZX81 cursor at beginning of display file
ENDIF
	ret
