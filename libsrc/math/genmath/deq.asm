;
;       Z88dk Generic Floating Point Math Library
;
;	TOS >= FA
;
;       $Id: deq.asm,v 1.1 2008-07-27 21:44:57 aralbrec Exp $:

		XLIB	deq

		LIB	dcompar
		LIB	f_yes
		LIB	f_no

.deq	call dcompar
	jp	z,f_yes
	jp	f_no

