;       Z88 Small C+ Run Time Library 
;       Long functions
;

SECTION code_clib
SECTION code_l_sccz80

PUBLIC l_long_lneg

EXTERN error_lznc

l_long_lneg:

   ; deHL = !deHL
   ; set carry if result true and return val in dehl

   ld a,h
   or l
   or e
   or d
   
   jp nz, error_lznc

   inc l
   
   scf
   ret
