;
;	Jupiter ACE Routines
;
;	Print character to the screen
;
;	$Id: fputc_cons.asm,v 1.5 2016-05-15 20:15:45 dom Exp $
;

	SECTION	code_clib
	PUBLIC  fputc_cons_native

;
; Entry:        char to print
;


.fputc_cons_native
	ld	hl,2
	add	hl,sp
	ld	a,(hl)	; Now A contains the char to be printed
IF STANDARDESCAPECHARS
	cp	13
	ret	z		; ignore CR
	cp	10		; LF - map to CR
	jr	nz,nolf
	ld	a,13
ENDIF
.nolf
	cp	12		; CLS
	jp	z,$a24
	cp	8		; BACKSPACE
	jr	nz,nobs
	ld	hl,$3C1C
	dec (hl)
	ret
.nobs
	jp	$3ff
