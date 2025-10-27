
SECTION code_clib
SECTION code_l

PUBLIC l_incu_hl

l_incu_hl:

   ; uses : hl
   ; z set on overflow

   inc l
   ret nz
   
   inc h
   ret nz
   
   dec hl
   ret
