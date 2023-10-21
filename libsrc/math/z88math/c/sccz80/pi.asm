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

        SECTION code_fp
  IF    FORz88
        INCLUDE "target/z88/def/fpp.def"
  ELSE
        INCLUDE "fpp.def"
  ENDIF

        PUBLIC  pi

        EXTERN  stkequ2

pi:
  IF    FORz88
        fpp     (FP_PI)
  ELSE
        ld      a, +(FP_PI)
        call    FPP
  ENDIF
        jp      stkequ2



