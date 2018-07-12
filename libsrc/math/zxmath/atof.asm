;
;       ZX Maths Routines
;
;       9/12/02 - Stefano Bodrato
;
;       $Id: atof.asm,v 1.5 2016-06-22 19:59:18 dom Exp $
;


;double atof(char *)     - convert string to number, leave in fa

IF FORts2068
		INCLUDE  "target/ts2068/def/ts2068fp.def"
ENDIF
IF FORzx
		INCLUDE  "target/zx/def/zxfp.def"
ENDIF
IF FORzx81
		INCLUDE  "target/zx81/def/81fp.def"
ENDIF
IF FORlambda
		INCLUDE  "target/lambda/def/lambdafp.def"
ENDIF

                SECTION  code_fp
                PUBLIC    atof

                EXTERN	stkequ

;.casave		defw	0

.atof
		pop	hl
		pop	de	;the string
		push	de
		push	hl

		ld	hl,(ZXFP_CH_ADD)
		push	hl
		
.nobloop	ld	a,(de)			; load the first number digit in A
		cp	' '			; skip spaces
		jr	nz,noblank
		inc	de
		jr	nobloop
.noblank	
		cp	'-'
		push	af
		jr	nz,noneg
		inc	de
		ld	a,(de)
.noneg

IF (FORzx | FORts2068)
ELSE
		ld	hl,txtbuffer
		push	hl
.nloop
		cp	0
		jr	z,converted
		sub	20
		cp	26
		jr	nz,nodot
		ld	a,27
.nodot
		ld	(hl),a
		inc	hl
		inc	de
		ld	a,(de)
		jr	nloop
 
.txtbuffer	defs	15

.converted
		ld	a,$76
		ld	(de),a
		pop	de
		ld	a,(de)
		
ENDIF

		ld	(ZXFP_CH_ADD),de		; Init the BASIC interpreter pointer
		call	ZXFP_DEC_TO_FP		; ask BASIC to load the string into a number
		
		pop	af
		jr	nz,noneg1
		rst	ZXFP_BEGIN_CALC
IF FORlambda
	defb	ZXFP_NEGATE + 128
ELSE
	defb	ZXFP_NEGATE
	defb	ZXFP_END_CALC
ENDIF
.noneg1

		pop	hl
		ld	(ZXFP_CH_ADD),hl		; restore the pointer

		jp      stkequ
