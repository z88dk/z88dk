;
;	TI86 Routines
;
;	Print character to the screen
;       We will corrupt any register
;
;       Stefano Bodrato - 9/5/2000
;

          XLIB  fputc_cons

;
; Entry:        hl points char to print
;


.fputc_cons
	ld	hl,2
	add	hl,sp

	ld	a,(hl)
	
	cp	12	; CLS ?
	jp	z,$4A82
	cp	13	; CR?
	jp	z,$4A5F

;	cp	32
;	ret	c
	
.nocr

	call	$4a2b
	ret

