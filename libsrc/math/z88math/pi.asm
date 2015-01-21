;
;
;       Z88 Maths Routines
;
;       C Interface for Small C+ Compiler
;
;	30th August 2003
;
;	$Id: pi.asm,v 1.3 2015-01-21 10:56:30 stefano Exp $


;double pi(void) - returns the value of pi

                INCLUDE  "fpp.def"

                PUBLIC    pi

                EXTERN	stkequ2

.pi
        fpp(FP_PI)
        jp      stkequ2



