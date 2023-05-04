;
;
;       ZX Maths Routines
;
;       9/12/02 - Stefano Bodrato
;
;       $Id: float.asm $
;



;Convert from integer to FP..
;We could enter in here with a long in dehl, so, mod to compiler I think!

; Note: this could become much smaller (abt 100 bytes saved) if we avoid 
; to use long datatypes; if so, just define TINYMODE.

; Stefano 23-05-2006 - now they are less than 100 bytes saved, got rid of the broken 
; normalization and added a terrific, compact and slow 256*256*MSW+LSW formula ! 

;
; For the Spectrum only a call to RESTACK will be used in stkequ for a real conversion
; (otherwise the ROM would keep the number coded as a 2 bytes word to optimize for speed).


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
		PUBLIC	float
		EXTERN	stkequ
		EXTERN	l_long_neg
		
.float
	bit	7,d
	push	af
	call	nz,l_long_neg
	ld	b,h
	ld	c,l
	push	de
	call	ZXFP_STACK_BC	; LSW
	pop	bc
	call	ZXFP_STACK_BC	; MSW
	ld	bc,256
	push	bc
	call	ZXFP_STACK_BC
	pop	bc
	call	ZXFP_STACK_BC

	rst	ZXFP_BEGIN_CALC
	defb	ZXFP_MULTIPLY
	defb	ZXFP_MULTIPLY
IF FORlambda
	defb	ZXFP_ADDITION + 128
ELSE
	defb	ZXFP_ADDITION
	defb	ZXFP_END_CALC

	pop	af
	jr	z,nointneg

	rst	ZXFP_BEGIN_CALC
IF FORlambda
	defb	ZXFP_NEGATE +128
ELSE
	defb	ZXFP_NEGATE
	defb	ZXFP_END_CALC
ENDIF

.nointneg

ENDIF

	jp	stkequ
