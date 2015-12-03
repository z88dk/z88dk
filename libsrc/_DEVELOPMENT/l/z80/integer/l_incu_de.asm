
SECTION code_clib
SECTION code_l

PUBLIC l_incu_de

l_incu_de:

   ; uses : af, de
   ; carry set on overflow

   inc de
   
   ld a,d
   or e
   ret nz
   
   ld de,$ffff
   scf
   ret
