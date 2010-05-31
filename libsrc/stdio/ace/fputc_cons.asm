;
;	Jupiter ACE Routines
;
;	Print character to the screen
;
;	$Id: fputc_cons.asm,v 1.3 2010-05-31 10:32:57 stefano Exp $
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
	ld	hl,$3C1C
	dec (hl)
	ret
.nobs
	jp	$3ff
