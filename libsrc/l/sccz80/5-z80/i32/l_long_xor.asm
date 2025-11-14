;       Z88 Small C+ Run Time Library 
;       Long functions
;

SECTION code_clib
SECTION code_l_sccz80

PUBLIC l_long_xor

l_long_xor:

   ; dehl  = secondary
   ; stack = primary, ret
   
   pop ix
   
   pop bc
   
   ld a,c
   xor l
   ld l,a
   
   ld a,b
   xor h
   ld h,a
   
   pop bc
   
   ld a,c
   xor e
   ld e,a
   
   ld a,b
   xor d
   ld d,a
   
   jp (ix)
