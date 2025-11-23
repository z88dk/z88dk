
; double sqrt(double x)

SECTION code_clib
SECTION code_fp_math48

PUBLIC am48_sqrt

EXTERN mm48_sqr

   ; sqrt(AC')
   ;
   ; enter : AC' = double x
   ;
   ; exit  : success
   ;
   ;           AC' = sqrt(x)
   ;           carry reset
   ;
   ;         fail if x < 0
   ;
   ;           AC' = 0
   ;           carry set, errno set
   ;
   ; uses  : af, af', bc', de', hl'

defc am48_sqrt = mm48_sqr
