;
;       Small C+ Runtime Library
;
;       CP/M functions
;
;       CPM Plus "userf" custom Amstrad calls, for Amstrad CPC & PCW and ZX Spectrum +3
;
;       $Id: a_keyspeed.asm,v 1.3 2017-01-02 20:06:48 aralbrec Exp $
;


        SECTION code_clib

	PUBLIC    a_keyspeed
   PUBLIC    _a_keyspeed
	
	EXTERN	subuserf
	INCLUDE	"amstrad_userf.def"

a_keyspeed:
_a_keyspeed:

	ld	hl,2
	add	hl,sp
	ld	a,(hl)	;subsequent delay
	inc	hl
	inc	hl
	ld	h,(hl)	;initial delay
	ld l,a
	call subuserf
	defw	KM_SET_SPEED
	ret
