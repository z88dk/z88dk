;
;       Z80 ANSI Library
;
;---------------------------------------------------
;       A different fputc_cons with ANSI support
;
;	Stefano Bodrato - 21/4/2000
;
;	$Id: fputc_cons.asm,v 1.7 2016-05-15 20:15:45 dom Exp $
;

	SECTION		code_clib
          PUBLIC  fputc_cons_ansi
	  EXTERN	f_ansi

;
; Entry:        hl = points to char
;
.fputc_cons_ansi
	ld      hl,2
	add     hl,sp
	ld      de,1	; one char buffer (!)
	jp      f_ansi
