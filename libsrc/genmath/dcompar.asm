;
;       Z88dk Generic Floating Point Math Library
;
;       common routine for double precision comparisons
;
;       $Id: dcompar.asm,v 1.2 2007-10-12 14:49:16 stefano Exp $:


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
