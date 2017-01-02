;
;       Small C+ Runtime Library
;
;       CP/M functions
;
;       CPM Plus "userf" custom Amstrad calls, for Amstrad CPC & PCW and ZX Spectrum +3
;
;
;       $Id: a_memsize.asm,v 1.2 2017-01-02 20:06:48 aralbrec Exp $
;

	SECTION code_clib

	PUBLIC	a_memsize
   PUBLIC   _a_memsize
	
	EXTERN	subuserf
	INCLUDE	"amstrad_userf.def"

a_memsize:
_a_memsize:
	call subuserf
	defw CD_INFO
	ld l,b
	ld h,0
	ret

