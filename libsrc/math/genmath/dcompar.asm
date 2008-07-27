;
;       Z88dk Generic Floating Point Math Library
;
;       common routine for double precision comparisons
;
;       $Id: dcompar.asm,v 1.1 2008-07-27 21:44:57 aralbrec Exp $:


		XLIB	dcompar

		LIB	compare

.dcompar
	POP    HL      ;save 1st return addr
        POP     AF      ;save 2nd return addr
        POP     DE      ;get number to compare
        POP     IX 
        POP     BC
        PUSH    AF      ;replace 2nd addr
        PUSH    HL      ;replace 1st addr, fall into...
	jp	compare
