
; double floor(double x)

SECTION code_clib
SECTION code_fp_math48

PUBLIC am48_floor

EXTERN am48_modf, am48_dconst_1, am48_dsub

am48_floor:

   ; Return largest integer not greater than x.
   ;
   ; enter : AC' = double x
   ;
   ; exit  : AC' = floor(x)
   ;
   ; notes : floor(-3.7) = -4
   ;         floor( 3.7) =  3
   ;
   ; uses  : af, bc, de, hl, af', bc', de', hl'

   call am48_modf
   exx
   
   ; AC = frac(x)
   ; AC'= int(x)
   
   bit 7,b
   ret z                       ; return if frac(x) > 0
   
   inc l
   dec l
   ret z                       ; return if frac(x) == 0
   
   call am48_dconst_1          ; AC = 1
   jp am48_dsub                ; return int(x)-1
