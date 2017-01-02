;
;       Small C+ Runtime Library
;
;       CP/M functions
;
;       CPM Plus "userf" custom Amstrad calls, for Amstrad CPC & PCW and ZX Spectrum +3
;
;
;       $Id: a_curx.asm,v 1.3 2017-01-02 20:06:48 aralbrec Exp $
;

	SECTION code_clib

	PUBLIC	a_curx
   PUBLIC   _a_curx
	
	EXTERN	subuserf
	INCLUDE	"amstrad_userf.def"

a_curx:
_a_curx:
	call subuserf
	defw TE_ASK
	;ld l,h
	ld h,0
	ret

