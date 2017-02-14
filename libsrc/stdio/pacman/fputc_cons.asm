;
;	PacMan hardware
;
;	Print character to the screen
;
;	Feb 2017 - Stefano Bodrato
;
;
;	$Id:$
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
	ret
