
SECTION code_clib
SECTION code_fp_math48

PUBLIC am48_ddiv

EXTERN mm48_fpdiv

   ; compute AC'/AC
   ;
   ; enter : AC'= double y
   ;         AC = double x
   ;
   ; exit  : AC = double x
   ;
   ;         success
   ;
   ;           AC'= y/x
   ;           carry reset
   ;
   ;         fail if divide by zero
   ;
   ;           AC'= +-inf
   ;           carry set, errno set
   ;
   ; uses  : af, af', bc', de', hl'

defc am48_ddiv = mm48_fpdiv
