
	INCLUDE "graphics/grafix.inc"

	SECTION	  code_clib

	PUBLIC    __v1050_byte

	EXTERN    v1050_sendchar
	EXTERN    v1050_sendchar_fast

;
;       $Id: __v1050_byte.asm $
;

; We obviously pass byte values in binary mode, LSB + MSB forced to zero
__v1050_byte:
	push af
	ld l,'='
	call v1050_sendchar
	pop af
	ld l,a
	call v1050_sendchar_fast
	ld l,0
	call v1050_sendchar
	ret
