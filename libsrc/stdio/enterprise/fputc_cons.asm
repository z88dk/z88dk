;
;	Enterprise 64/128 C Library
;
;	Fputc_cons
;
;	Stefano Bodrato - 2011
;
;
;	$Id: fputc_cons.asm,v 1.1 2011-02-17 20:44:23 stefano Exp $
;

	XLIB  fputc_cons


;
; Entry:        hl = points to char
;
.fputc_cons
	ld      hl,2
	add     hl,sp
	ld      a,(hl)
	ld      b,a
	ld      a,66h	; output channel (video)
	rst     30h		; EXOS
	defb    7	; character output
	ret

