;
;	ZX81 libraries - Stefano
;
;----------------------------------------------------------------
;
; $Id: scrolldowntxt.asm,v 1.4 2015-01-19 01:33:26 pauloscustodio Exp $
;
;----------------------------------------------------------------
; Text scrolldown.
;----------------------------------------------------------------

    PUBLIC   scrolldowntxt
    EXTERN    zx_topleft

scrolldowntxt:
	ld	hl,(16396)
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
