;
;       Z80 ANSI Library
;
;---------------------------------------------------
;       A different fputc_cons with ANSI support
;
;	Stefano Bodrato - 21/4/2000
;
;	$Id: fputc_cons.asm,v 1.6 2016-04-04 18:31:22 dom Exp $
;

	SECTION		code_clib
          PUBLIC  fputc_cons
          PUBLIC  _fputc_cons
	  EXTERN	f_ansi

;
; Entry:        hl = points to char
;
.fputc_cons
._fputc_cons
	ld      hl,2
	add     hl,sp
	ld      de,1	; one char buffer (!)
	jp      f_ansi
