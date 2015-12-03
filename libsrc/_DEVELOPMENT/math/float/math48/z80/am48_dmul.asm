
SECTION code_clib
SECTION code_fp_math48

PUBLIC am48_dmul

EXTERN mm48_fpmul

   ; compute AC' = AC * AC'
   ;
   ; enter : AC'= double x
   ;         AC = double y
   ;
   ; exit  : AC = double y
   ;
   ;         success
   ;
   ;           AC'= x*y
   ;           carry reset
   ;
   ;         fail if overflow
   ;
   ;           AC'= +-inf
   ;           carry set, errno set
   ;
   ; uses  : af, af', bc', de', hl'

defc am48_dmul = mm48_fpmul
