;
;	ZX81 libraries - Stefano
;
;----------------------------------------------------------------
;
; $Id: scrolldowntxt.asm $
;
;----------------------------------------------------------------
; Text scrolldown.
;----------------------------------------------------------------

        SECTION code_clib
    PUBLIC   scrolldowntxt
    PUBLIC   _scrolldowntxt
    EXTERN    zx_topleft

scrolldowntxt:
_scrolldowntxt:
IF FORlambda
	ld	hl,16509
ELSE
	ld	hl,(16396)	; D_FILE
ENDIF
	ld	bc,33*24
	add	hl,bc
	ld	de,33
	push hl
	add hl,de
	pop de
	ex de,hl
	lddr
	xor a
	ld b,32
blankline:
	inc hl
	ld (hl),a
	djnz blankline
	jp zx_topleft
