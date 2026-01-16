
SECTION code_clib
SECTION code_fp_math32

PUBLIC mlib2d

   ; convert math32 float to sdcc_float
   ; suprise, they're the same thing!
   ;
   ; enter : DEHL' = math32 float
   ;
   ; exit  : DEHL  = sdcc_float
   ;         (exx set is swapped)
   ;
   ; uses  : bc, de, hl, bc', de', hl'
   
.mlib2d
   exx
   ret
