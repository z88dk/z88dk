;
;       ZX Maths Routines
;
;       6/12/02 - Stefano Bodrato
;
;       $Id: fsetup.asm,v 1.2 2009-06-22 21:44:17 dom Exp $
;



; Set up the registers for our operation
; Peeks the parameter from stack


IF FORzx
		INCLUDE  "zxfp.def"
ELSE
		INCLUDE  "81fp.def"
ENDIF


                XLIB    fsetup
		LIB	fsetup1
 
.fsetup 
	
	ld	hl,9		; 4 (ret locations) + 5 (mantissa)
	add	hl,sp		;ret to this function and ret to code
	
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

	pop	hl		; save the locatrions for ret
	pop	de
	pop	bc		; get rid of fp number
	pop	bc
	pop	bc
	push	de		; restore the locatrions for ret
	push	hl
	jp	fsetup1

