;
;	ABC80 Routines
;
;	Print character to the screen
;
;       We can corrupt any register
;
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
	ld	a,(hl); Now A contains the char to be printed
	
	cp	13
	jr	nz,nocrlf
	ld	a,13
	call	printchar
	ld	a,10
.nocrlf
	cp	12	; CLS
	jp	z,$276

.printchar
	ld	bc,1
	ld	hl,mychar
	ld	(hl),a
	jp	1a8h

.mychar	defb	0
