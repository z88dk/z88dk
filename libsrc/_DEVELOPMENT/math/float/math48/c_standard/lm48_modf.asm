
; double modf(double value, double *iptr)

SECTION code_fp_math48

PUBLIC lm48_modf

EXTERN mm48_equal, mm48_int, mm48_fpsub

lm48_modf:

   ; Break value into integer and fraction parts
   ;
   ; enter : AC'(BCDEHL') = double value
   ;
   ; exit  : AC'(BCDEHL ) = frac(value)
   ;         AC (BCDEHL') = int(value)
   ;
   ; uses  : af, bc, de, hl, af', bc', de', hl'

   exx
   call mm48_equal
   call mm48_int
   exx
   jp mm48_fpsub
