
; double pow(double x, double y)

SECTION code_clib
SECTION code_fp_math48

PUBLIC am48_pow

EXTERN mm48_pwr

   ; compute (AC')^(AC)
   ;
   ; enter : AC' = double x
   ;         AC  = double y
   ;
   ; exit  : success
   ;
   ;           AC' = x^y
   ;           carry reset
   ;
   ;         fail if out of domain or overflow
   ;
   ;           AC' = +-inf or zero
   ;           carry set, errno set
   ;
   ; uses  : af, af', bc', de', hl'

defc am48_pow = mm48_pwr
