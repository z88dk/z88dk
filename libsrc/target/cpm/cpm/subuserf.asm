;
;       Small C+ Runtime Library
;
;       CP/M functions
;
;       CPM Plus "userf" custom Amstrad calls, for Amstrad CPC & PCW and ZX Spectrum +3
;
;       $Id: subuserf.asm,v 1.4 2017-01-02 20:06:48 aralbrec Exp $
;


        SECTION code_clib

	PUBLIC    subuserf
   PUBLIC    _subuserf

subuserf:             ;FIND USERF AND CALL IT.
_subuserf:
	push hl
	push de
	ld hl,($0001)
	ld de,$0057
	add hl,de
	pop de
	ex (sp),hl
	ret
