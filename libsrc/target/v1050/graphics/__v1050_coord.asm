
	INCLUDE "graphics/grafix.inc"

	SECTION	  code_clib

	PUBLIC    __v1050_coord

	EXTERN     l_cmp

	EXTERN    __gfx_coords
	EXTERN    v1050_sendchar
	EXTERN    v1050_sendchar_fast

;
;       $Id: __v1050_coord.asm $
;


;;--------------------------------------------------
;; Binary to BCD conversion
;;
;;
;; input: HL = unsigned integer to convert
;; output: C:DE = 4-digit BCD number
;;--------------------------------------------------

__v1050_coord:
	push de


; Converts HL into a BCD number

	ld b,16  ; handle 16 bits,one bit per iteration
	;ld c,0
	LD	DE,0
cvtLoop:
	ADD	HL,HL
	LD	A,E
	ADC	A,A
	DAA
	LD	E,A
	LD	A,D
	ADC	A,A
	DAA
	LD	D,A
;	LD	A,C
;	ADC	A,A
;	DAA
;	LD	C,A
	DJNZ cvtLoop
;	EX	HL,DE

	ld a,d
	and $0f
	add '0'
	ld l,a
	call v1050_sendchar_fast
	
	ld a,e
	srl a
	srl a
	srl a
	srl a
	and $0f
	add '0'
	ld l,a
	call v1050_sendchar

	ld a,e
	and $0f
	add '0'
	ld l,a
	call v1050_sendchar

	pop de
	RET
