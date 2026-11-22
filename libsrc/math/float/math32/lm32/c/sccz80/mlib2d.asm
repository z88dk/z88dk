
SECTION code_clib
SECTION code_fp_math32

PUBLIC mlib2d

   ; convert math32 float to sccz80_float
   ; suprise, they're the same thing!
   ;
   ; enter : DEHL' = math32 float
   ;
   ; exit  : DEHL  = scz80_float
   ;         (exx set is swapped)
   ;
   ; uses  : bc, de, hl, bc', de', hl'
   
.mlib2d
   exx
   ret
