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
;	$Id: fputc_cons.asm,v 1.4 2015-01-19 01:33:21 pauloscustodio Exp $
;

          PUBLIC  fputc_cons

;
; Entry:        char to print on stack
;

.fputc_cons

		ld	hl,2
		add	hl,sp
		ld	a,(hl)
	
		cp	12	; CLS ?
		jr	nz,nocls
		xor	a
		jp	$014E
.nocls
		jp	$10
