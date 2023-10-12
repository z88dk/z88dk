;
;       Z88dk Z88 Maths Library
;
;
;       $Id: ddiv.asm,v 1.4 2016-06-22 19:55:06 dom Exp $

        SECTION code_fp
        PUBLIC  ddiv

        EXTERN  fsetup
        EXTERN  stkequ

  IF    FORz88
        INCLUDE "target/z88/def/fpp.def"
  ELSE
        INCLUDE "fpp.def"
  ENDIF

ddiv:
        call    fsetup
  IF    FORz88
        fpp     (FP_DIV)
  ELSE
        ld      a, +(FP_DIV)
        call    FPP
  ENDIF
        jp      stkequ

