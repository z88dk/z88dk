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
;	$Id: fputc_cons.asm,v 1.3 2003-02-04 09:10:25 stefano Exp $
;

          XLIB  fputc_cons

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
