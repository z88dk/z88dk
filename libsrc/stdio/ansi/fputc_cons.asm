;
;       Z80 ANSI Library
;
;---------------------------------------------------
;       A different fputc_cons with ANSI support
;
;	Stefano Bodrato - 21/4/2000
;
;	$Id: fputc_cons.asm,v 1.2 2001-04-13 14:13:59 stefano Exp $
;

          XLIB  fputc_cons
	  LIB	f_ansi

;
; Entry:        hl = points to char
;
.fputc_cons
	ld      hl,2
	add     hl,sp
	ld      de,1	; one char buffer (!)
	jp      f_ansi
	ret
