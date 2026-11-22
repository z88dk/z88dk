
SECTION code_clib
SECTION code_fp_math48

PUBLIC am48_dsub

EXTERN mm48_fpsub

   ; floating point subtract
   ; AC' = AC' - AC
   ;
   ; enter : AC'= double x
   ;         AC = double y
   ;
   ; exit  : AC = double y
   ;
   ;         success
   ;
   ;            AC'= x - y
   ;            carry reset
   ;
   ;         fail if overflow
   ;
   ;            AC'= +-inf
   ;            carry set, errno set
   ;
   ; uses  : af, af', bc', de', hl'

defc am48_dsub = mm48_fpsub
