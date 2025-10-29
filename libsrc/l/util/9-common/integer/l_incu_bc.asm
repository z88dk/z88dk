
SECTION code_clib
SECTION code_l

PUBLIC l_incu_bc

l_incu_bc:

   ; uses : bc
   ; z set on overflow

   inc c
   ret nz
   
   inc b
   ret nz
   
   dec bc
   ret
