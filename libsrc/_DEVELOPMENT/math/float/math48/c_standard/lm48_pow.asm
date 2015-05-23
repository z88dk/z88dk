
; double pow(double x, double y)

SECTION code_fp_math48

PUBLIC lm48_pow

EXTERN mm48_pwr

   ; compute x^y
   ;
   ; enter : AC'(BCDEHL') = double x
   ;         AC (BCDEHL ) = double y
   ;
   ; exit  : success
   ;
   ;           AC'(BCDEHL') = x^y
   ;           carry reset
   ;
   ;         fail if out of domain or overflow
   ;
   ;           AC'(BCDEHL') = double_min, double_max or zero
   ;           carry set, errno set
   ;
   ; uses  : af, af', bc', de', hl'

defc lm48_pow = mm48_pwr
