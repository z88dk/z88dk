;
;	Enterprise 64/128 C Library
;
;	Fputc_cons
;
;	Stefano Bodrato - 2011
;
;
;	$Id: fputc_cons.asm,v 1.3 2011-02-28 07:02:02 stefano Exp $
;

	XLIB  fputc_cons


;
; Entry:        hl = points to char
;
.fputc_cons
	ld      hl,2
	add     hl,sp
	ld      a,(hl)
	cp      13
	jr      nz,nocr
	call    doput
	ld      a,10
	jr      doput
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

