
; double scalbn(double x, int n)

SECTION code_clib
SECTION code_fp_math48

PUBLIC am48_scalbn

EXTERN am48_ldexp

   ; compute AC' * FLT_RADIX^n efficiently
   ;
   ; enter : AC' = double x
   ;         HL  = n
   ;
   ; exit  : success
   ;
   ;            AC' = x * 2^n
   ;            carry reset
   ;
   ;         fail if overflow
   ;
   ;            AC' = +-inf
   ;            carry set, errno set
   ;
   ; uses  : af, bc', de', hl'

defc am48_scalbn = am48_ldexp
