
; double log(double x)

SECTION code_clib
SECTION code_fp_math48

PUBLIC am48_log

EXTERN mm48_ln

   ; compute natural logarithm of AC'
   ;
   ; enter : AC' = double x
   ;
   ; exit  : success
   ;
   ;           AC' = ln(x)
   ;           carry reset
   ;
   ;         fail on domain error
   ;
   ;           AC' = -inf
   ;           carry set, errno set
   ;
   ; uses  : af, af', bc', de', hl'

defc am48_log = mm48_ln
