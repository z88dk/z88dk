;       Z88 Small C+ Run Time Library 
;       Long functions
;

SECTION code_clib
SECTION code_l_sccz80

PUBLIC l_long_bool

l_long_bool:

   ; HL = !!HL

   ld a,h
   or l
   or d
   or e
   ret z
   
   ld hl,1
   ld e,h
   ld d,h
   
   ret
