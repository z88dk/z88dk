;
;	Old School Computer Architecture - interfacing FLOS
;	Stefano Bodrato, 2011
;
;	Internal routine to manage FLOS errors
;
;	$Id: flos_err.asm,v 1.3 2016-06-22 22:13:09 dom Exp $
;

    INCLUDE "flos.def"

        SECTION code_clib
	PUBLIC  flos_err
	PUBLIC  _flos_err

flos_err:
_flos_err:
	ld	hl,0
	ret	z	; 0 = OK
	ld	l,a	; 1->255 ..FLOS error
	and	a
	ret nz
hw_err:
	ld	h,b	; > 255 .. hardware error
	ret
