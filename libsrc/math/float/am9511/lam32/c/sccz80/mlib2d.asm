
SECTION code_clib
SECTION code_fp_am9511

PUBLIC mlib2d

   ; convert am9511 float to sccz80_float
   ; suprise, they're the same thing!
   ;
   ; enter : DEHL' = am9511 float
   ;
   ; exit  : DEHL  = sccz80_float
   ;         (exx set is swapped)
   ;
   
.mlib2d
   exx
   ret
