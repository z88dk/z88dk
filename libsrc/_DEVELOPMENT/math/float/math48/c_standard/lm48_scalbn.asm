
; double scalbn(double x, int n)

SECTION code_fp_math48

PUBLIC lm48_scalbn

EXTERN lm48_ldexp

   ; compute x * FLT_RADIX^n efficiently
   ;
   ; enter : AC'(BCDEHL') = double x
   ;                  HL  = n
   ;
   ; exit  : success
   ;
   ;            AC'(BCDEHL') = x * 2^n
   ;            carry reset
   ;
   ;         fail if overflow
   ;
   ;            AC'(BCDEHL') = double_max or double_min
   ;            carry set, errno set
   ;
   ; uses  : af, hl, bc', de', hl'

defc lm48_scalbn = lm48_ldexp
