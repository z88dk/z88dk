;
;       Small C+ Runtime Library
;
;       CP/M functions
;
;       CPM Plus "userf" custom Amstrad calls, for Amstrad CPC & PCW and ZX Spectrum +3
;
;
;       $Id: a_driveb.asm,v 1.2 2017-01-02 20:06:48 aralbrec Exp $
;

	SECTION code_clib

	PUBLIC	a_driveb
   PUBLIC   _a_driveb
	
	EXTERN	subuserf
	INCLUDE	"amstrad_userf.def"

a_driveb:
_a_driveb:
	call subuserf
	defw CD_INFO
	ld l,a
	ld h,0
	ret

