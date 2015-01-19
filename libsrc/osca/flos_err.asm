;
;	Old School Computer Architecture - interfacing FLOS
;	Stefano Bodrato, 2011
;
;	Internal routine to manage FLOS errors
;
;	$Id: flos_err.asm,v 1.2 2015-01-19 01:33:00 pauloscustodio Exp $
;

    INCLUDE "flos.def"

	PUBLIC  flos_err

flos_err:
	ld	hl,0
	ret	z	; 0 = OK
	ld	l,a	; 1->255 ..FLOS error
	and	a
	ret nz
hw_err:
	ld	h,b	; > 255 .. hardware error
	ret
