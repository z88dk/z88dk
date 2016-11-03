;
;       Small C+ Runtime Library
;
;       CP/M functions
;
;       CPM Plus "userf" custom Amstrad calls, for Amstrad CPC & PCW and ZX Spectrum +3
;
;       $Id: subuserf.asm,v 1.3 2016-11-03 09:25:27 stefano Exp $
;


        SECTION code_clib

	PUBLIC    subuserf

subuserf:             ;FIND USERF AND CALL IT.
	push hl
	push de
	ld hl,($0001)
	ld de,$0057
	add hl,de
	pop de
	ex (sp),hl
	ret
