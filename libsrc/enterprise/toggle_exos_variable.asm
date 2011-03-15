;
;	Enterprise 64/128 specific routines
;	by Stefano Bodrato, 2011
;
;	toggle_exos_variable(unsigned char variable);
;
;
;	$Id: toggle_exos_variable.asm,v 1.2 2011-03-15 14:34:08 stefano Exp $
;

	XLIB	toggle_exos_variable

;_FASTCALL_

toggle_exos_variable:

	ld	b,2		; TOGGLE mode
	ld	c,l		; Variable
	rst   30h
	defb  16	; SET_GET_EXOS_VARIABLE
	ld	h,0
	ld	l,d

	ret
