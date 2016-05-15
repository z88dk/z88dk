;
;   SEGA SC-3000 C Library
;
;	Print character to the screen
;
;	$Id: fputc_cons.asm,v 1.3 2016-05-15 20:15:46 dom Exp $
;

	  SECTION code_clib
          PUBLIC  fputc_cons_native

;
; Entry:        a= char to print
;


.fputc_cons_native
	ld	hl,2
	add	hl,sp
	ld	a,(hl)
IF STANDARDESCAPECHARS
	cp	10
ELSE
	cp	13
ENDIF
	jr	nz,nocr
	call	$2400
IF STANDARDESCAPECHARS
	ld	a,13
ELSE
	ld	a,10
ENDIF
.nocr
	jp	$2400
