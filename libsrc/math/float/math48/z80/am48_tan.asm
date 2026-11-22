
; double tan(double x)

SECTION code_clib
SECTION code_fp_math48

PUBLIC am48_tan

EXTERN mm48_tan

   ; compute tan(AC')
   ;
   ; enter : AC' = double x in radians
   ;
   ; exit  : success
   ;
   ;            AC' = tan(x)
   ;            carry reset
   ;
   ;         fail if cos(x)=0
   ;
   ;            AC' = +-inf
   ;            carry set, errno set
   ;
   ; uses  : af, af', bc', de', hl'

defc am48_tan = mm48_tan
