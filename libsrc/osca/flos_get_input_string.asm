;
;	Old School Computer Architecture - interfacing FLOS
;	Stefano Bodrato, 2012
;
;	Get line from console
;
;	$Id: flos_get_input_string.asm,v 1.3 2016-06-22 22:13:09 dom Exp $
;

    INCLUDE "flos.def"

        SECTION code_clib
	PUBLIC  flos_get_input_string
	PUBLIC  _flos_get_input_string
	
flos_get_input_string:
_flos_get_input_string:
	pop de
	pop bc
	ld	a,c
	pop hl
	push hl
	push bc
	push de
	
	push bc
	push hl
	call	kjt_get_input_string
	pop de
	pop bc
	and a
	jr	nz,copystr
	ld (de),a
	ret
	
copystr:
	ld b,0
	ldir
	xor a
	ld (de),a
	ret
