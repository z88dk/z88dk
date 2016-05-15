;
;       SAM Coupé C Library
;
;	Print character to the screen
;
;       We will corrupt any register
;
;
;	Frode Tennebø - 29/12/2002
;
;	$Id: fputc_cons.asm,v 1.5 2016-05-15 20:15:46 dom Exp $
;

	  SECTION code_clib
          PUBLIC  fputc_cons_native

;
; Entry:        char to print on stack
;

.fputc_cons_native

		ld	hl,2
		add	hl,sp
		ld	a,(hl)
IF STANDARDESCAPECHARS
		cp	10
		jr	nz,nocr
		ld	a,13
ENDIF
.nocr	
		cp	12	; CLS ?
		jr	nz,nocls
		xor	a
		jp	$014E
.nocls
		jp	$10
