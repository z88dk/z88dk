
SECTION code_clib
SECTION code_l

PUBLIC l_incu_bc

l_incu_bc:

   ; uses : af, bc
   ; carry set on overflow

   inc bc
   
   ld a,b
   or c
   ret nz
   
   ld bc,$ffff
   scf
   ret
