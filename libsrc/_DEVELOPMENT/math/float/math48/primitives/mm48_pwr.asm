
SECTION code_fp_math48

PUBLIC mm48_pwr

EXTERN mm48_error_edom_zc, mm48__retzero
EXTERN mm48_ln, mm48_fpmul, mm48_exp

mm48_pwr:

   ; power
   ; AC' = AC'^AC = exp(AC*ln(AC'))
   ;
   ; enter : AC'(BCDEHL') = float x
   ;         AC (BCDEHL ) = float y
   ;
   ; exit  : success
   ;
   ;            AC'= x^y
   ;            carry reset
   ;
   ;         fail if domain error
   ;
   ;            AC'= double_max, double_min or zero
   ;            carry set, errno set
   ;
   ; uses  : af, af', bc', de', hl'

;X^Y beregnes af EXP(Y*LN(X)).

   call mm48_ln
   jp c, mm48_error_edom_zc    ; if x <= 0
   
   call mm48_fpmul
   jp nc, mm48_exp

   ; multiply overflowed

   exx

   bit 7,b
   jp nz, mm48__retzero        ; if -inf return zero without error

   exx
   ret
