;
;       Small C+ Runtime Library
;
;       CP/M functions
;
;       CPM Plus "userf" custom Amstrad calls, for Amstrad CPC & PCW and ZX Spectrum +3
;
;
;       $Id: a_serialport.asm,v 1.2 2017-01-02 20:06:48 aralbrec Exp $
;

	SECTION code_clib

	PUBLIC	a_serialport
   PUBLIC   _a_serialport
	
	EXTERN	subuserf
	INCLUDE	"amstrad_userf.def"

a_serialport:
_a_serialport:
	call subuserf
	defw CD_INFO
	ld l,c
	ld h,0
	ret

