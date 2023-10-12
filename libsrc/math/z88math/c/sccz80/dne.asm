;
;       Z88dk Z88 Maths Library
;
;
;       $Id: dne.asm,v 1.4 2016-06-22 19:55:06 dom Exp $

        SECTION code_fp
        PUBLIC  dne

        EXTERN  fsetup
        EXTERN  stkequcmp

  IF    FORz88
        INCLUDE "target/z88/def/fpp.def"
  ELSE
        INCLUDE "fpp.def"
  ENDIF

; TOS != FA?
dne:
        call    fsetup
  IF    FORz88
        fpp     (FP_EQ)
  ELSE
        ld      a, +(FP_EQ)
        call    FPP
  ENDIF
;Invert the result, not particularly elegant, but it works!
        ex      de, hl
        ld      hl, 0
        ld      a, e
        or      d
        jp      nz, stkequcmp
        inc     hl
        jp      stkequcmp

