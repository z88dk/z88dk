;
;       Small C+ Runtime Library
;
;       CP/M functions
;
;       CPM Plus "userf" custom Amstrad calls, for Amstrad CPC & PCW and ZX Spectrum +3
;
;       $Id: subuserf.asm,v 1.1 2016-10-31 13:51:06 stefano Exp $
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
