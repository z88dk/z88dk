
SECTION code_clib
SECTION code_l

PUBLIC l_long_inc_mhl, l0_long_inc_mhl

l_long_inc_mhl:

   ; djm 26/2/2000, aralbrec 01/2007
   ;
   ; enter : hl = unsigned long *
   ;
   ; exit  ; unsigned long at address hl is incremented
   ;
   ; uses  : f, hl

   inc (hl)
   ret nz
   
   inc hl
   inc (hl)
   ret nz

l0_long_inc_mhl:

   inc hl
   inc (hl)
   ret nz
   
   inc hl
   inc (hl)
   ret
