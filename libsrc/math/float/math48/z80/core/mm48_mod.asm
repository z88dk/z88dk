
SECTION code_clib
SECTION code_fp_math48

PUBLIC mm48_mod

EXTERN mm48_fpdiv, mm48_frac, mm48_fpmul

mm48_mod:

   ; modulus
   ; AC' = AC' % AC
   ;
   ; enter : AC'(BCDEHL') = float x
   ;         AC (BCDEHL ) = float y
   ;
   ; note  : AC'= x % y = frac(x/y)*y
   ;         The result has the same sign as x.
   ;
   ; exit  : AC unchanged
   ;
   ;         success
   ;
   ;            AC'(BCDEHL') = x % y
   ;            carry reset
   ;
   ;         fail if divide by zero
   ;
   ;            AC'(BCDEHL') = float_min or float_max
   ;            carry set, errno set
   ;
   ; uses  : af, af', bc', de', hl'

   call mm48_fpdiv
   ret c
   call mm48_frac
   jp mm48_fpmul
