;
;
;       Z88 Maths Routines
;
;       C Interface for Small C+ Compiler
;
;       30/1/20001 djm


;double atof(char *)     - convert string to number, leave in fa

        SECTION code_fp
  IF    FORz88
        INCLUDE "target/z88/def/fpp.def"
  ELSE
        INCLUDE "fpp.def"
  ENDIF

        PUBLIC  atof

        EXTERN  stkequ2

atof:
        pop     de
  IF    FORz88
        pop     hl                      ;the string
        push    hl
  ELSE
        pop     ix
        push    ix
  ENDIF
        push    de
  IF    FORz88
        fpp     (FP_VAL)
  ELSE
        ld      a, +(FP_VAL)
        call    FPP
  ENDIF
        jp      stkequ2



