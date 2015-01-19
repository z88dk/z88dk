;
;	Jupiter ACE Routines
;
;	Print character to the screen
;
;	$Id: fputc_cons.asm,v 1.4 2015-01-19 01:33:17 pauloscustodio Exp $
;

	PUBLIC  fputc_cons

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
