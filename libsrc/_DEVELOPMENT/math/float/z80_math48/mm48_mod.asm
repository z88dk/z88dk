
SECTION code_fp_math48

PUBLIC mm48_mod

EXTERN mm48_fpdiv, mm48_frac, mm48_fpmul

mm48_mod:

;     Modulus
;     -------
;
;     NAME:      MOD
;     FUNCTION:  AC=AC MOD AC' or AC=FRAC(AC/AC')*AC'. AC is set
;                equal to the remainder of the division of AC by AC'.
;                The result has the same sign as AC.
;     OFFSET:    0CH
;     OUTPUT:    CF=0: OK.
;                CF=1: Division AC/AC' gives overflow, or
;                      AC' is 0.
;     STACK:     22 bytes.

   call mm48_fpdiv
   ret c
   call mm48_frac
   jp mm48_fpmul
