;
;	Philips P2000 Routines
;
;	Print character to the screen
;
;	Apr 2014 - Stefano Bodrato
;
;
;	$Id: fputc_cons.asm,v 1.3 2015-01-19 01:33:21 pauloscustodio Exp $
;

	PUBLIC  fputc_cons

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
