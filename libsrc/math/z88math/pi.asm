;
;
;       Z88 Maths Routines
;
;       C Interface for Small C+ Compiler
;
;	30th August 2003
;
;	$Id: pi.asm,v 1.1 2008-07-27 21:44:58 aralbrec Exp $


;double pi(void) - returns the value of pi

                INCLUDE  "#fpp.def"

                XLIB    pi

                LIB	stkequ2

.pi
        fpp(FP_PI)
        jp      stkequ2



