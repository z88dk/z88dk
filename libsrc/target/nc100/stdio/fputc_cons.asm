;
;	Put character to console
;
;	fputc_cons(char c)
;
;
;	$Id: fputc_cons.asm,v 1.5+ (now on GIT) $
;


		SECTION code_clib
		PUBLIC	fputc_cons_native


.fputc_cons_native
	ld	hl,2
	add	hl,sp
	ld	a,(hl)
	cp 12
	jp	z,$B824	;TXTCLEARWINDOW (cls)
IF STANDARDESCAPECHARS
	cp	10
ELSE
	cp	13
ENDIF
	jr	nz,fputc_cons1
	ld	a,13
	call	$B833	;txtoutput
	ld	a,10
.fputc_cons1
	jp	$B833	;txtoutput

