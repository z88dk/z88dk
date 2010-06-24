;
;   SEGA SC-3000 C Library
;
;	Print character to the screen
;
;	$Id: fputc_cons.asm,v 1.1 2010-06-24 09:05:52 stefano Exp $
;

          XLIB  fputc_cons

;
; Entry:        a= char to print
;


.fputc_cons
	ld	hl,2
	add	hl,sp
	ld	a,(hl)
	cp	13
	jr	nz,nocr
	call	$2400
	ld	a,10
.nocr
	jp	$2400
