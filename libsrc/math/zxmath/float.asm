;
;
;       ZX Maths Routines
;
;       9/12/02 - Stefano Bodrato
;
;       $Id: float.asm,v 1.4 2015-01-19 01:32:57 pauloscustodio Exp $
;



;Convert from integer to FP..
;We could enter in here with a long in dehl, so, mod to compiler I think!

; Note: this could become much smaller (abt 100 bytes saved) if we avoid 
; to use long datatypes; if so, just define TINYMODE.

; Stefano 23-05-2006 - now they are less than 100 bytes saved, got rid of the broken 
; normalization and added a terrific, compact and slow 256*256*MSW+LSW formula ! 

;
; For the Spectrum only a call to RESTACK will be used in stkequ for a real conversion
; (otherwise the ROM keeps the number coded as a 2 bytes word to optimize for speed).


IF FORzx
		INCLUDE  "zxfp.def"
ELSE
		INCLUDE  "81fp.def"
ENDIF

                PUBLIC	float
		EXTERN	stkequ
.float
IF TINYMODE

	ld	b,h
	ld	c,l
	bit	7,d		; is it	negative ?
	push	af
	call	ZXFP_STACK_BC 
	pop	af
	jr	z,nointneg

	rst	ZXFP_BEGIN_CALC
	defb	ZXFP_NEGATE
	defb	ZXFP_END_CALC

.nointneg
	

ELSE

	ld	b,h
	ld	c,l
	bit	7,d		; is it	negative ?
	push	af
	ld	a,127
	and	d
	ld	d,a
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
	defb	ZXFP_ADDITION
	defb	ZXFP_END_CALC

	pop	af
	jr	z,nointneg

	rst	ZXFP_BEGIN_CALC
	defb	ZXFP_NEGATE
	defb	ZXFP_END_CALC

.nointneg

ENDIF

	jp	stkequ
