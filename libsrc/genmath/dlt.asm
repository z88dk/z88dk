;
;       Z88dk Generic Floating Point Math Library
;
;	TOS >= FA
;
;       $Id: dlt.asm,v 1.1 2002-01-21 20:35:22 dom Exp $:

		XLIB	dlt

		LIB	dcompar
		LIB	f_yes
		LIB	f_no

.dlt	call dcompar
	jp	z,f_no
	jp	p,f_yes
	jp	f_no

