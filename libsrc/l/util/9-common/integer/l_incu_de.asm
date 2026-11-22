
SECTION code_clib
SECTION code_l

PUBLIC l_incu_de

l_incu_de:

   ; uses : de
   ; z set on overflow

   inc e
   ret nz
   
   inc d
   ret nz
   
   dec de
   ret
