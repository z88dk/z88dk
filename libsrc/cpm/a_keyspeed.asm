;
;       Small C+ Runtime Library
;
;       CP/M functions
;
;       CPM Plus "userf" custom Amstrad calls, for Amstrad CPC & PCW and ZX Spectrum +3
;
;       $Id: a_keyspeed.asm,v 1.2 2016-11-03 09:25:27 stefano Exp $
;


        SECTION code_clib

	PUBLIC    a_keyspeed
	
	EXTERN	subuserf
	INCLUDE	"amstrad_userf.def"

a_keyspeed:

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
