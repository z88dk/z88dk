;
;	Put character to console
;
;	fputc_cons(char c)
;
;
;	$Id: fputc_cons.asm,v 1.5 2016-05-15 20:15:45 dom Exp $
;


		SECTION code_clib
		PUBLIC	fputc_cons_native


.fputc_cons_native
	ld	hl,2
	add	hl,sp
	ld	a,(hl)
IF STANDARDESCAPECHARS
	cp	10
ELSE
	cp	13
ENDIF
	jr	nz,fputc_cons1
	call	$B833	;txtoutput
IF STANDARDESCAPECHARS
	ld	a,13
ELSE
	ld	a,10
ENDIF
.fputc_cons1
	jp	$B833	;txtoutput

