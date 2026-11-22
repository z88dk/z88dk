
; double log10(double x)

SECTION code_clib
SECTION code_fp_math48

PUBLIC am48_log10

EXTERN mm48_log

   ; compute base-10 log of AC'
   ;
   ; enter : AC' = double x
   ;
   ; exit  : success
   ;
   ;            AC' = log(x)
   ;            carry reset
   ;
   ;         fail if domain error
   ;
   ;            AC' = -inf
   ;            carry set, errno set
   ;
   ; uses  : af, af', bc', de', hl'

defc am48_log10 = mm48_log
