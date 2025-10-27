
; double ceil(double x)

SECTION code_clib
SECTION code_fp_math48

PUBLIC am48_ceil

EXTERN am48_modf, am48_dconst_1, am48_dadd

am48_ceil:

   ; Return smallest integer not less than x.
   ;
   ; enter : AC' = double x
   ;
   ; exit  : AC' = ceil(x)
   ;
   ; notes : ceil(-3.7) = -3
   ;         ceil( 3.7) =  4
   ;
   ; uses  : af, bc, de, hl, af', bc', de', hl'

   call am48_modf
   exx
   
   ; AC = frac(x)
   ; AC'= int(x)
   
   bit 7,b
   ret nz                      ; return if frac(x) < 0
   
   inc l
   dec l
   ret z                       ; return if frac(x) == 0
   
   call am48_dconst_1          ; AC = 1
   jp am48_dadd                ; return frac(x)+1
