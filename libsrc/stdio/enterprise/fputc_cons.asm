;
;	Enterprise 64/128 C Library
;
;	Fputc_cons
;
;	Stefano Bodrato - 2011
;
;
;	$Id: fputc_cons.asm,v 1.2 2011-02-27 11:58:46 stefano Exp $
;

	XLIB  fputc_cons


;
; Entry:        hl = points to char
;
	ld      hl,2
	add     hl,sp
	ld      a,(hl)

.fputc_cons
	cp      13
	jr      nz,nocr
	call    doput
	ld      a,10
	jr      doput
.nocr
	cp      12
	jr      nz,doput
;	ld      a,1ah	;CLEAR-HOME

.doput
	ld      b,a
	ld      a,66h	; output channel (video)
	rst     30h		; EXOS
	defb    7	; character output
	ret

