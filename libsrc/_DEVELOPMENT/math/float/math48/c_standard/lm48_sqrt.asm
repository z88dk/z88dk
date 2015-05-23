
; double sqrt(double x)

SECTION code_fp_math48

PUBLIC lm48_sqrt

EXTERN mm48_sqr

   ; compute sqrt(x)
   ;
   ; enter : AC'(BCDEHL') = x
   ;
   ; exit  : success
   ;
   ;           AC'(BCDEHL') = sqrt(x)
   ;           carry reset
   ;
   ;         fail if x < 0
   ;
   ;           AC'(BCDEHL') = 0
   ;           carry set, errno set
   ;
   ; uses  : af, af', bc', de', hl'

defc lm48_sqrt = mm48_sqr
 