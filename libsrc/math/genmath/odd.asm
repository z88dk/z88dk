;       Small C+ Math Library - Support routine
;       Negate a fp number push address

        SECTION code_fp
        PUBLIC    odd
        EXTERN     minusfa

;
;       negate FA, and push address of MINUSFA
;       called to evaluate functions f(x) when the argument is
;       negative and f() satisfies f(-x)=-f(x)
.odd    CALL    minusfa
        LD      HL,minusfa
        EX      (SP),HL
        JP      (HL)
;

