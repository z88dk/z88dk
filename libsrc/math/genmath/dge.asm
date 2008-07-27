;
;       Z88dk Generic Floating Point Math Library
;
;	TOS >= FA
;
;       $Id: dge.asm,v 1.1 2008-07-27 21:44:57 aralbrec Exp $:

		XLIB	dge

		LIB	dcompar
		LIB	f_yes
		LIB	f_no

.dge	call dcompar
	jp	z,f_yes
	jp	p,f_no
	jp	f_yes

