;
;
;       Z88 Maths Routines
;
;       C Interface for Small C+ Compiler
;
;	30th August 2003
;
;	$Id: pi.asm,v 1.1 2003-08-30 18:24:04 dom Exp $


;double pi(void) - returns the value of pi

                INCLUDE  "#fpp.def"

                XLIB    pi

                LIB	stkequ2

.pi
        fpp(FP_PI)
        jp      stkequ2



