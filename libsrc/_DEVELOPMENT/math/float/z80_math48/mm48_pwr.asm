
SECTION code_fp_math48

PUBLIC mm48_pwr

EXTERN mm48_ln, mm48_fpmul, mm48_exp

mm48_pwr:

;     Power
;     ------
;
;     NAME:      PWR
;     FUNKTZON:  AC=AC^AC' or AC=EXP(AC'*LN(AC)). AC is set equal
;                to AC raised to the exponent given in AC'.
;     OFFSET:    0FH
;     OUTPUT:    CF=0: OK.
;                CF=1:  Overflow.
;     STACK:     12 bytes.

;X^Y beregnes af EXP(Y*LN(X)).

   ld a,l
   or a
   ret z
   call mm48_ln
   ret c
   call mm48_fpmul
   ret c
   jp mm48_exp
