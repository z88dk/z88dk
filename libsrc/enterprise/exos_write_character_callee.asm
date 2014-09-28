;
;	Enterprise 64/128 specific routines
;	by Stefano Bodrato, 2011
;
;	exos_write_character(unsigned char ch_number, char character);
;
;
;	$Id: exos_write_character_callee.asm,v 1.3 2014-09-28 18:26:58 pauloscustodio Exp $
;


XLIB	exos_write_character_callee
XDEF 	ASMDISP_EXOS_WRITE_CHARACTER_CALLEE

exos_write_character_callee:

	pop hl
	pop de
	ex (sp),hl

; enter : e = unsigned char chr
;         l = unsigned char chan

.asmentry

	ld	a,l		; Variable
	ld	b,e		; Value
	rst   30h
	defb  7
	ld	h,0
	ld	l,a
	ret


DEFC ASMDISP_EXOS_WRITE_CHARACTER_CALLEE = # asmentry - exos_write_character_callee
 
