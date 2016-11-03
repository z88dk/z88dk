;
;       Small C+ Runtime Library
;
;       CP/M functions
;
;       CPM Plus "userf" custom Amstrad calls, for Amstrad CPC & PCW and ZX Spectrum +3
;
;       $Id: a_border.asm,v 1.2 2016-11-03 09:25:27 stefano Exp $
;

	SECTION code_clib

	PUBLIC	a_border
	
	EXTERN	subuserf
	INCLUDE	"amstrad_userf.def"

a_border:
	ld b,l
	call subuserf
	defw TE_SET_BORDER
	ret

