;
;       SAM Coupe C Library
;
;	Print character to the screen
;
;       We will corrupt any register
;
;       Stefano Bodrato - Mar.2001


          XLIB  fputc_cons

;
; Entry:        hl points char to print
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

