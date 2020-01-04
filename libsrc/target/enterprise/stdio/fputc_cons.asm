;
;	Enterprise 64/128 C Library
;
;	Fputc_cons
;
;	Stefano Bodrato - 2011
;
;
;	$Id: fputc_cons.asm,v 1.5 2016-05-15 20:15:45 dom Exp $
;

	SECTION code_clib
	PUBLIC  fputc_cons_native


;
; Entry:        hl = points to char
;
.fputc_cons_native
	ld      hl,2
	add     hl,sp
	ld      a,(hl)
IF STANDARDESCAPECHARS
	cp	10
ELSE
	cp      13
ENDIF
	jr      nz,nocr
	call    doput
IF STANDARDESCAPECHARS
	ld	a,13
ELSE
	ld      a,10
ENDIF
.nocr
	cp      12
	jr      nz,doput
	ld      a,1ah	;CLEAR-HOME

.doput
	ld      b,a
	ld      a,66h	; output channel (video)
	rst     30h		; EXOS
	defb    7	; character output
	ret

