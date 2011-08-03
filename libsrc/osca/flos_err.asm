;
;	Old School Computer Architecture - interfacing FLOS
;	Stefano Bodrato, 2011
;
;	Internal routine to manage FLOS errors
;
;	$Id: flos_err.asm,v 1.1 2011-08-03 08:13:40 stefano Exp $
;

    INCLUDE "flos.def"

	XLIB  flos_err

flos_err:
	ld	hl,0
	ret	z	; 0 = OK
	ld	l,a	; 1->255 ..FLOS error
	and	a
	ret nz
hw_err:
	ld	h,b	; > 255 .. hardware error
	ret
