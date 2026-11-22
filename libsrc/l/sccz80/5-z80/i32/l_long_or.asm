;       Z88 Small C+ Run Time Library 
;       Long functions
;

SECTION code_clib
SECTION code_l_sccz80

PUBLIC l_long_or

l_long_or:

   ; dehl = primary
   ; stack = secondary, ret

   pop ix
   
   pop bc
   
   ld a,c
   or l
   ld l,a
   
   ld a,b
   or h
   ld h,a
   
   pop bc
   
   ld a,c
   or e
   ld e,a
   
   ld a,b
   or d
   ld d,a
   
   jp (ix)
