;
;       ZX Maths Routines
;
;       30/12/02 - Stefano Bodrato
;
;       $Id: fsetupf.asm,v 1.5 2016-06-22 19:59:18 dom Exp $
;



; Set up the registers for our operation 
; Peeks the parameter from stack: C parameter passing mode
; used by pow only, for now. Maybe atan2 in the future.


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
		PUBLIC    fsetupf
		EXTERN	fsetup1
 
.fsetupf
	
	ld	hl,15
	add	hl,sp
	
	ld	a,(hl)
	dec	hl
	ld	e,(hl)
	dec	hl
	ld	d,(hl)
	dec	hl
	ld	c,(hl)
	dec	hl
	ld	b,(hl)
	; load in the FP calculator stack	
	call	ZXFP_STK_STORE

	jp	fsetup1

