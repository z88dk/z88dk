;
;       Z88dk Generic Floating Point Math Library
;
;	TOS >= FA
;
;       $Id: dne.asm,v 1.1 2002-01-21 20:35:22 dom Exp $:

		XLIB	dne

		LIB	dcompar
		LIB	f_yes
		LIB	f_no

.dne	call dcompar
	jp	nz,f_yes
	jp	f_no

