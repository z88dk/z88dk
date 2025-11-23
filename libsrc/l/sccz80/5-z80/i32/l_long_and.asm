;       Z88 Small C+ Run Time Library 
;       Long functions
;

SECTION code_clib
SECTION code_l_sccz80

PUBLIC l_long_and

l_long_and:

   ; primary = dehl
   ; stack = secondary, ret
   ; 90 cycles

   pop ix
   
   pop bc
   ld a,c
   and l
   ld l,a
   ld a,b
   and h
   ld h,a

   pop bc
   ld a,c
   and e
   ld e,a
   ld a,b
   and d
   ld d,a
   
   jp (ix)
