
; double fmod(double x, double y)

SECTION code_clib
SECTION code_fp_math48

PUBLIC am48_fmod

EXTERN mm48_mod

   ; computes result of AC' % AC
   ;
   ; enter : AC  = double y
   ;         AC' = double x
   ;
   ; exit  : success
   ;
   ;           AC' = x%y with sign the same as x
   ;           carry reset
   ;
   ;         fail divide by zero
   ;
   ;           AC' = +-inf (same sign as x)
   ;           carry set, errno set
   ;
   ; uses   : af, af', bc', de', hl'

defc am48_fmod = mm48_mod
