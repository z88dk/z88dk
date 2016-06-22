;
;
;       Z88 Maths Routines
;
;       C Interface for Small C+ Compiler
;
;	30th August 2003
;
;	$Id: pi.asm,v 1.4 2016-06-22 19:55:06 dom Exp $


;double pi(void) - returns the value of pi

                SECTION  code_fp
                INCLUDE  "fpp.def"

                PUBLIC    pi

                EXTERN	stkequ2

.pi
        fpp(FP_PI)
        jp      stkequ2



