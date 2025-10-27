
; double modf(double value, double *iptr)

SECTION code_clib
SECTION code_fp_math48

PUBLIC am48_modf

EXTERN am48_dequate, am48_dip, am48_dsub

am48_modf:

   ; Break AC' into integer and fraction parts
   ;
   ; enter : AC' = double x
   ;
   ; exit  : AC' = frac(x)
   ;         AC  = int(x)
   ;
   ; uses  : af, bc, de, hl, af', bc', de', hl'

   exx
   
   call am48_dequate
   call am48_dip
   
   exx
   
   jp am48_dsub
