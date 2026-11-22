
SECTION code_clib
SECTION code_l

PUBLIC l_addu_hl_de

l_addu_hl_de:

   ; uses : hl, f
   ; carry set on overflow
   
   add hl,de
   ret nc
   
   ld hl,$ffff
   ret
