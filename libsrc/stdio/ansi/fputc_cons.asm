;
;       Z80 ANSI Library
;
;---------------------------------------------------
;       A different fputc_cons with ANSI support
;
;	Stefano Bodrato - 21/4/2000
;
;	$Id: fputc_cons.asm,v 1.3 2015-01-19 01:33:18 pauloscustodio Exp $
;

          PUBLIC  fputc_cons
	  EXTERN	f_ansi

;
; Entry:        hl = points to char
;
.fputc_cons
	ld      hl,2
	add     hl,sp
	ld      de,1	; one char buffer (!)
	jp      f_ansi
	ret
