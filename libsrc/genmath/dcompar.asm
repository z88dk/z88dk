;
;       Z88dk Generic Floating Point Math Library
;
;       common routine for double precision comparisons
;
;       $Id: dcompar.asm,v 1.1 2002-01-21 20:35:22 dom Exp $:


		XLIB	dcompar

		LIB	compare

.dcompar
	POP    HL      ;save 1st return addr
        POP     IY      ;save 2nd return addr
        POP     DE      ;get number to compare
        POP     IX
        POP     BC
        PUSH    IY      ;replace 2nd addr
        PUSH    HL      ;replace 1st addr, fall into...
	jp	compare


