;
;	Amstrad CPC Stdio
;
;	putchar - puts a character
;	(HL)=char to display
;
;	Stefano Bodrato - 8/6/2001
;
;
;	$Id: fputc_cons.asm,v 1.1 2001-06-12 14:28:47 stefano Exp $
;

	XLIB	fputc_cons

.fputc_cons
	ld	hl,2
	add	hl,sp
	ld	a,(hl)
	cp	13	; CR ?
	jr	nz,nocr
	call	$BB5A
	ld	a,10
.nocr
	jp 	$BB5A
