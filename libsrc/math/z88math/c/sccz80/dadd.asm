;
;       Z88dk Z88 Maths Library
;
;
;       $Id: dadd.asm,v 1.4 2016-06-22 19:55:06 dom Exp $

        SECTION code_fp
        PUBLIC  dadd

        EXTERN  fsetup
        EXTERN  stkequ

  IF    FORz88
        INCLUDE "target/z88/def/fpp.def"
  ELSE
        INCLUDE "fpp.def"
  ENDIF

dadd:
        call    fsetup
  IF    FORz88
        fpp     (FP_ADD)
  ELSE
        ld      a, +(FP_ADD)
        call    FPP
  ENDIF
        jp      stkequ

