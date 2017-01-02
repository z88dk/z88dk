;
;       Small C+ Runtime Library
;
;       CP/M functions
;
;       CPM Plus "userf" custom Amstrad calls, for Amstrad CPC & PCW and ZX Spectrum +3
;
;       $Id: a_statusline.asm,v 1.4 2017-01-02 20:06:48 aralbrec Exp $
;


        SECTION code_clib

	PUBLIC    a_statusline
   PUBLIC    _a_statusline
	
	EXTERN	subuserf
	INCLUDE	"amstrad_userf.def"

a_statusline:
_a_statusline:
	xor a
	or l
	jr z,is_off
	ld a,255
is_off:

	call subuserf
	defw	TE_STL_ON_OFF
	ret
