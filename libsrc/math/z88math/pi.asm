;
;
;       Z88 Maths Routines
;
;       C Interface for Small C+ Compiler
;
;	30th August 2003
;
;	$Id: pi.asm,v 1.2 2009-06-22 21:44:17 dom Exp $


;double pi(void) - returns the value of pi

                INCLUDE  "fpp.def"

                XLIB    pi

                LIB	stkequ2

.pi
        fpp(FP_PI)
        jp      stkequ2



