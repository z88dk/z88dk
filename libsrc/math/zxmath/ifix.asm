;
;
;       ZX Maths Routines
;
;       9/12/02 - Stefano Bodrato
;
;       $Id: ifix.asm,v 1.5 2016-06-22 19:59:18 dom Exp $
;


; Convert fp in FA to a long or an integer (if in tiny mode)
; DEHL keeps the value, CARRY has the overflow bit


IF FORzx
		INCLUDE  "zxfp.def"
ENDIF
IF FORzx81
		INCLUDE  "81fp.def"
ENDIF
IF FORlambda
		INCLUDE  "lambdafp.def"
ENDIF

                SECTION  code_fp
                PUBLIC    ifix

.ifix

; If you want to get rid of the long support, define "TINYMODE".
; I wouldn't suggest it if you have 16K it because only 
; 109 bytes with ifix and about the same with "float" are saved.

 
IF TINYMODE

	EXTERN	fsetup1

	call	fsetup1
	defb	ZXFP_END_CALC
	call	ZXFP_FP_TO_BC
	ld	h,b
	ld	l,c
	ret
ELSE

	EXTERN	fa
	EXTERN	l_long_neg

	;call	fsetup1
	;defb	ZXFP_END_CALC
	;CALL	ZXFP_STK_FETCH	; exponent to A
	;			; mantissa to EDCB.

	;;  ### let's optimize a bit for speed... ###
	ld	hl,fa+5
	ld	a,(hl)
	dec	hl
	ld	e,(hl)
	dec	hl
	ld	d,(hl)
	dec	hl
	ld	c,(hl)
	dec	hl
	ld	b,(hl)
	;; ####################################


	AND	A		; test for value zero.
	JR	NZ,nonzero
	LD	D,A		; zero to D
	LD	E,A		; also to E
	LD	H,A		; also to H
	LD	L,A		; also to L
.nonzero
; ---

; EDCB	=>  DEHL
;( EDCB	 =>  BCE)
	push	af
	ld	l,b
	ld	h,c
	ld	a,e
	ld	e,d
	ld	d,a
	pop	af

	sub	@10100001	; subtract 131072 (@10100001)
				; was: 65536 (@10010001)
	CCF			; complement carry flag
	BIT	7,D		; test sign bit
	PUSH	AF		; push the result
	
	SET	7,D		; set the implied bit
	jr	c,doexit	; Too big !
	
	INC	A		; increment the	exponent and
	NEG			; negate to make range $00 - $0F
	
	CP	32		; test if four bytes
	JR	C,bigint

.byroll
	ld	l,h		; Roll mantissa	8 bits -> right
	ld	h,e
	ld	e,d
	ld	d,0
	sub	8
	cp	8
	jr	nc,byroll

.bigint
	and	a		; Have we normalized?
				; (fractionals)
	ld	c,a		; save exponent in C
	ld	a,l
	rlca			; rotate most significant bit to carry for
				; rounding of an already normal number.
	jr	z,expzero

;; FPBC-NORM
	
.biroll				; Still	not, do	the bit	shifting
	srl	d		;   0->76543210->C
	rr	e		;   C->76543210->C
	rr	h		;   C->76543210->C
	rr	l		;   C->76543210->C
	dec	c		; decrement exponent
	jr	nz,biroll
	
.expzero
	jr	nc,doexit
	ld	bc,1		; round up
	add	hl,bc		; increment lower pair
	jr	nc,nocround
	inc	de		; inc upper pair if needed

.nocround
	ld	a,d		; test result for zero
	or	e
	or	h
	or	l
	jr	nz,doexit
	pop	af
	scf			; set carry flag to indicate overflow
	push	af
.doexit
	pop	af
	call	nz,l_long_neg	; Negate if negative
.noneg
	ret
ENDIF
