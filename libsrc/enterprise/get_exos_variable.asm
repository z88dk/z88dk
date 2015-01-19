;
;	Enterprise 64/128 specific routines
;	by Stefano Bodrato, 2011
;
;	get_exos_variable(unsigned char variable);
;
;
;	$Id: get_exos_variable.asm,v 1.3 2015-01-19 01:32:43 pauloscustodio Exp $
;

	PUBLIC	get_exos_variable

;_FASTCALL_

get_exos_variable:

	ld	b,0		; GET mode
	ld	c,l		; Variable
	rst   30h
	defb  16	; SET_GET_EXOS_VARIABLE
	ld	h,0
	ld	l,d

	ret
