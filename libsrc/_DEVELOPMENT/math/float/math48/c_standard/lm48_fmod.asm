
; double fmod(double x, double y)

SECTION code_fp_math48

PUBLIC lm48_fmod

EXTERN mm48_mod

   ; computes result of x%y
   ;
   ; enter : AC (BCDEHL ) = double y
   ;         AC'(BCDEHL') = double x
   ;
   ; exit  : success
   ;
   ;           AC'(BCDEHL') = x%y with sign the same as x
   ;           carry reset
   ;
   ;         fail divide by zero
   ;
   ;           AC'(BCDEHL') = double_min or double_max (same sign as x)
   ;           carry set, errno set
   ;
   ; uses   : af, af', bc', de', hl'

defc lm48_fmod = mm48_mod
