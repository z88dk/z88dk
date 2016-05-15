;
;	Philips P2000 Routines
;
;	Print character to the screen
;
;	Apr 2014 - Stefano Bodrato
;
;
;	$Id: fputc_cons.asm,v 1.4 2016-05-15 20:15:46 dom Exp $
;

	SECTION	code_clib
	PUBLIC  fputc_cons_native

;
; Entry:        char to print
;


fputc_cons_native:
	ld	hl,2
	add	hl,sp
	ld	a,(hl); Now A contains the char to be printed
	
	cp 95
	jr nz,nounderscore
	ld a,92
	jr doputc
nounderscore:
IF STANDARDESCAPECHARS
	cp	10
ELSE
	cp  13
ENDIF
	jr  nz,doputc
	call doputc
IF STANDARDESCAPECHARS
	ld	a,13
ELSE
	ld  a,10
ENDIF

doputc:
	jp  $60C0
