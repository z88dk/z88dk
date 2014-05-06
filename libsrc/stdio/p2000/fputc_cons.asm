;
;	Philips P2000 Routines
;
;	Print character to the screen
;
;	Apr 2014 - Stefano Bodrato
;
;
;	$Id: fputc_cons.asm,v 1.2 2014-05-06 06:23:37 stefano Exp $
;

	XLIB  fputc_cons

;
; Entry:        char to print
;


fputc_cons:
	ld	hl,2
	add	hl,sp
	ld	a,(hl); Now A contains the char to be printed
	
	cp 95
	jr nz,nounderscore
	ld a,92
	jr doputc
nounderscore:

	cp  13
	jr  nz,doputc
	call doputc
	ld  a,10

doputc:
	jp  $60C0
