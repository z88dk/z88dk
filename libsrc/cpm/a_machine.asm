;
;       Small C+ Runtime Library
;
;       CP/M functions
;
;       CPM Plus "userf" custom Amstrad calls, for Amstrad CPC & PCW and ZX Spectrum +3
;
;
;       $Id: a_machine.asm,v 1.3 2017-01-02 20:06:48 aralbrec Exp $
;

	SECTION code_clib

	PUBLIC	a_machine
   PUBLIC   _a_machine
	
	EXTERN	subuserf
	INCLUDE	"amstrad_userf.def"

a_machine:
_a_machine:
	call subuserf
	defw CD_VERSION
	ld l,a
	ld h,0
	ret

