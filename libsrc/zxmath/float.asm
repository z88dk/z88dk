;
;
;       ZX Maths Routines
;
;       9/12/02 - Stefano Bodrato
;
;       $Id: float.asm,v 1.1 2003-03-24 09:17:40 stefano Exp $
;



;Convert from integer to FP..
;We could enter in here with a long in dehl, so, mod to compiler I think!

; Note: this could become much smaller (abt 100 butes saved) if we avoid 
; to use long datatypes; if so, just define TINYMODE.
; For the Spectrum only a call to RESTACK will be used for a real conversion
; (otherwise the ROM keeps the word to optimize for speed).


IF FORzx
		INCLUDE  "#zxfp.def"
ELSE
		INCLUDE  "#81fp.def"
ENDIF

                XLIB	float
		LIB	stkequ
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
	defb	ZXFP_negate
	defb	ZXFP_END_CALC

.nointneg
	

ELSE
		LIB	l_long_neg

	push	hl
	push	de

	rst	ZXFP_BEGIN_CALC
	defb	ZXFP_STK_ZERO	; stack	zero, five zeroed bytes, to start.
	defb	ZXFP_END_CALC	; HL=points to the "number"

	pop	de
	pop	bc		; we keep the FP pointer in HL

	bit	7,d		; is it	negative ?
	push	af		; (save	the sign check flags)
	push	hl		; save the FP pointer
	ld	h,b
	ld	l,c
	call	nz,l_long_neg	; if yes, convert to positive;
	ld	b,h		; we'll	store the sign bit afterwards..
	ld	c,l		; ..save the number
	pop	hl		; restore the FP pointer
	
	LD	(HL),@11000001	; this is the maximum possible exponent
	LD	A,D		; fetch	hi-byte.
	AND	A		; test for zero.
	JR	NZ,stdgt

	LD	D,E		; scroll one byte left
	LD	E,B		; BC holds the lower part of the long value
	LD	B,C
	LD	C,A		; zero in C

	LD	(HL),@10100001	; First	byte was zero; let's try the next one
	LD	A,D
	AND	A		; test for zero.
	JR	NZ,stdgt

	LD	D,E		; scroll one byte left
	LD	E,B
	LD	B,A
;
	LD	(HL),@10010001	; lower	exponent and try with next
	LD	A,D
	AND	A		; test for zero.
	JR	NZ,stdgt

;----
	LD	D,E		; scroll one byte left (last one !)
	LD	E,A

	LD	(HL),@10001001	; lower	exponent
	LD	A,D
	AND	A		; test for zero.
	JR	NZ,stdgt

	LD	(HL),A		; else make exponent zero again
	pop	af
	jp	stkequ		; exit: long was zero.

.stdgt
	DEC	(HL)		; decrement exponent - halving number

	SLA	C		;  C<-76543210<-0
	RL	B		;  C<-76543210<-C
	RL	E		;  C<-76543210<-C
	RL	D		;  C<-76543210<-C

	JR	NC,stdgt	; loop back if no carry

	SRL	D		;  0->76543210->C
	RR	E		;  C->76543210->C
	RR	B		;  C->76543210->C
	RR	C		;  C->76543210->C


	pop	af		; restore the sign check result
	jr	z,waspos

	set 7,d
				; was negative,
				; so set the sign bit
				; in the exponent byte
.waspos
	INC	HL		; mantissa
	LD	(HL),D
	INC	HL
	LD	(HL),E
	INC	HL
	LD	(HL),B
	INC	HL
	LD	(HL),C

ENDIF

	jp	stkequ
