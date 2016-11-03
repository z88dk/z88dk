;
;       Small C+ Runtime Library
;
;       CP/M functions
;
;       CPM Plus "userf" custom Amstrad calls, for Amstrad CPC & PCW and ZX Spectrum +3
;
;
;       $Id: a_memsize.asm,v 1.1 2016-11-03 09:25:27 stefano Exp $
;

	SECTION code_clib

	PUBLIC	a_memsize
	
	EXTERN	subuserf
	INCLUDE	"amstrad_userf.def"

a_memsize:
	call subuserf
	defw CD_INFO
	ld l,b
	ld h,0
	ret

