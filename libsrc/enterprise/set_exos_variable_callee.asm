;
;	Enterprise 64/128 specific routines
;	by Stefano Bodrato, 2011
;
;	set_exos_variable(unsigned char variable, unsigned char value);
;
;
;	$Id: set_exos_variable_callee.asm,v 1.2 2011-03-15 14:34:08 stefano Exp $
;


XLIB	set_exos_variable_callee
XDEF 	ASMDISP_SET_EXOS_VARIABLE_CALLEE

set_exos_variable_callee:

	pop hl
	pop de
	ex (sp),hl

; enter : e = unsigned char value
;         l = unsigned char variable

.asmentry

	ld	b,1		; SET mode
	ld	c,l		; Variable
	ld	d,e		; Value
	rst   30h
	defb  16	; SET_GET_EXOS_VARIABLE
	ld	h,0
	ld	l,d
	ret


DEFC ASMDISP_SET_EXOS_VARIABLE_CALLEE = asmentry - set_exos_variable_callee
 
