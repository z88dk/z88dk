
; double exp(double x)

SECTION code_clib
SECTION code_fp_math48

PUBLIC am48_exp

EXTERN mm48_exp

   ; computes base-e exponential of AC'
   ;
   ; enter : AC' = double x
   ;
   ; exit  : success
   ;
   ;            AC' = e^x
   ;            carry reset
   ;
   ;         fail if overflow
   ;
   ;            AC' = +inf
   ;            carry set, errno set
   ;
   ; uses   : af, af', bc', de', hl'

defc am48_exp = mm48_exp
