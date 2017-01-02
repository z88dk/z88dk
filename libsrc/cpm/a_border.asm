;
;       Small C+ Runtime Library
;
;       CP/M functions
;
;       CPM Plus "userf" custom Amstrad calls, for Amstrad CPC & PCW and ZX Spectrum +3
;
;       $Id: a_border.asm,v 1.3 2017-01-02 20:06:48 aralbrec Exp $
;

	SECTION code_clib

	PUBLIC	a_border
   PUBLIC   _a_border
	
	EXTERN	subuserf
	INCLUDE	"amstrad_userf.def"

a_border:
_a_border:
	ld b,l
	call subuserf
	defw TE_SET_BORDER
	ret

