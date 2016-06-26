;
;	ZX81 libraries - Stefano
;
;----------------------------------------------------------------
;
;	$Id: zx_topleft.asm,v 1.6 2016-06-26 20:32:08 dom Exp $
;
;----------------------------------------------------------------
;
; Position the text cursor on top-left
;
;----------------------------------------------------------------

        SECTION code_clib
	PUBLIC   zx_topleft
	PUBLIC   _zx_topleft
	EXTERN   zx_dfile_addr

IF FORzx80
	DEFC   COLUMN=$4024    ; S_POSN_x
ELSE
	DEFC   COLUMN=$4039    ; S_POSN_x
ENDIF

zx_topleft:
_zx_topleft:
	ld  hl,$1821	; (33,24) = top left screen posn
	ld  (COLUMN),hl

IF FORzx80
	ld	hl,(16396)	; D_FILE
	ret
ELSE
    ;ld  ($400E),hl	; DF_CC ..position ZX81 cursor at beginning of display file
	jp	zx_dfile_addr
ENDIF

