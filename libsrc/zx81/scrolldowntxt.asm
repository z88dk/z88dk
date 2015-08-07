;
;	ZX81 libraries - Stefano
;
;----------------------------------------------------------------
;
; $Id: scrolldowntxt.asm,v 1.5 2015-08-07 06:23:57 stefano Exp $
;
;----------------------------------------------------------------
; Text scrolldown.
;----------------------------------------------------------------

    PUBLIC   scrolldowntxt
    EXTERN    zx_topleft

scrolldowntxt:
IF FORlambda
	ld	hl,16509 + (33*24)
ELSE
	ld	hl,(16396)	; D_FILE
	ld	bc,33*24
	add	hl,bc
ENDIF
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
