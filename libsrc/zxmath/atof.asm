;
;
;       ZX Maths Routines
;
;       9/12/02 - Stefano Bodrato
;
;       $Id: atof.asm,v 1.1 2003-03-24 09:17:40 stefano Exp $
;


;double atof(char *)     - convert string to number, leave in fa

IF FORzx
		INCLUDE  "#zxfp.def"
ELSE
		INCLUDE  "#81fp.def"
ENDIF

                XLIB    atof

                LIB	stkequ

;.casave		defw	0

.atof
		pop	hl
		pop	de	;the string
		push	de
		push	hl

		ld	hl,(ZXFP_CH_ADD)
		push	hl
		ld	a,(de)			; load the first number digit in A
		cp	'-'
		push	af
		jr	nz,noneg
		inc	de
		ld	a,(de)
.noneg

		ld	(ZXFP_CH_ADD),de		; Init the BASIC interpreter pointer
		call	ZXFP_DEC_TO_FP		; ask BASIC to load the string into a number
		
		pop	af
		jr	nz,noneg1
		rst	ZXFP_BEGIN_CALC
		defb	ZXFP_NEGATE
		defb	ZXFP_END_CALC
.noneg1

		pop	hl
		ld	(ZXFP_CH_ADD),hl		; restore the pointer

		jp      stkequ

