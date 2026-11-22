
SECTION code_clib
SECTION code_l

PUBLIC l_cpl_dehl, l_cpl_dehl_hl

l_cpl_dehl:

   ; uses : af, de, hl
   
   ld a,d
   cpl
   ld d,a
   
   ld a,e
   cpl
   ld e,a

l_cpl_dehl_hl:

   ld a,h
   cpl
   ld h,a
   
   ld a,l
   cpl
   ld l,a
   
   ret
