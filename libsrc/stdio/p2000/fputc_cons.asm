;
;	Philips P2000 Routines
;
;	Print character to the screen
;
;	Apr 2014 - Stefano Bodrato
;
;
;	$Id: fputc_cons.asm,v 1.1 2014-04-17 06:16:05 stefano Exp $
;

	XLIB  fputc_cons

;
; Entry:        char to print
;


fputc_cons:
	ld	hl,2
	add	hl,sp
	ld	a,(hl); Now A contains the char to be printed

	cp  13
	jr  nz,doputc
	call doputc
	ld  a,10

doputc:
	jp  $60C0
