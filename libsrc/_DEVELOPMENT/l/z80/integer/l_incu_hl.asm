
SECTION seg_code_l

PUBLIC l_incu_hl

l_incu_hl:

   ; uses : af, hl
   ; carry set on overflow

   inc hl
   
   ld a,h
   or l
   ret nz
   
   ld hl,$ffff
   scf
   ret
