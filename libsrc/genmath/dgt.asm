;
;       Z88dk Generic Floating Point Math Library
;
;	TOS >= FA
;
;       $Id: dgt.asm,v 1.1 2002-01-21 20:35:22 dom Exp $:

		XLIB	dgt

		LIB	dcompar
		LIB	f_yes
		LIB	f_no

.dgt	call dcompar
	jp	z,f_no
	jp	p,f_no
	jp	f_yes

