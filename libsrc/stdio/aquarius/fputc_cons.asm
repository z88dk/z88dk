;
;	Mattel Aquarius Routines
;
;	Print character to the screen
;
;       We can corrupt any register
;
;
;	$Id: fputc_cons.asm,v 1.1 2001-12-24 13:23:08 stefano Exp $
;

	XLIB  fputc_cons

;
; Entry:   char to print
;


.fputc_cons

	ld	hl,2
	add	hl,sp
	ld	a,(hl); Now A contains the char
	cp	13
	jr	nz,nocrlf
	call	$1d72
	ld	a,10
	jp	$1d72
.nocrlf
	cp	12
	jr	nz,nocls
	ld	a,$b
.nocls	
	;rst	$18
	;ret
	jp	$1d72
