;
;	ZX81 libraries - Stefano
;
;----------------------------------------------------------------
;
; $Id: scrolldowntxt.asm,v 1.3 2012-01-09 16:02:36 stefano Exp $
;
;----------------------------------------------------------------
; Text scrolldown.
;----------------------------------------------------------------

    XLIB   scrolldowntxt
    LIB    zx_topleft

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
