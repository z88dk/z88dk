;
;       Small C+ Runtime Library
;
;       CP/M functions
;
;       CPM Plus "userf" custom Amstrad calls, for Amstrad CPC & PCW and ZX Spectrum +3
;
;
;       $Id: a_machinever.asm,v 1.2 2017-01-02 20:06:48 aralbrec Exp $
;

	SECTION code_clib

	PUBLIC	a_machinever
   PUBLIC   _a_machinever
	
	EXTERN	subuserf
	INCLUDE	"amstrad_userf.def"

a_machinever:
_a_machinever:
	call subuserf
	defw CD_VERSION
	ret

