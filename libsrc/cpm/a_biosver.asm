;
;       Small C+ Runtime Library
;
;       CP/M functions
;
;       CPM Plus "userf" custom Amstrad calls, for Amstrad CPC & PCW and ZX Spectrum +3
;
;
;       $Id: a_biosver.asm,v 1.2 2017-01-02 20:06:48 aralbrec Exp $
;

	SECTION code_clib

	PUBLIC	a_biosver
   PUBLIC   _a_biosver
	
	EXTERN	subuserf
	INCLUDE	"amstrad_userf.def"

a_biosver:
_a_biosver:
	call subuserf
	defw CD_VERSION
	ld h,b
	ld l,c
	ret

