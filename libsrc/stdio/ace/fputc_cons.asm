;
;	Jupiter ACE Routines
;
;	Print character to the screen
;
;	$Id: fputc_cons.asm,v 1.2 2010-05-31 08:29:06 stefano Exp $
;

	XLIB  fputc_cons

;
; Entry:        char to print
;


.fputc_cons
	ld	hl,2
	add	hl,sp
	ld	a,(hl)	; Now A contains the char to be printed
	cp	12		; CLS
	jp	z,$a24
	cp	8		; BACKSPACE
	jr	nz,nobs
	ld	a,5
.nobs
	jp	$3ff
