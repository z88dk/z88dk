
SECTION code_clib
SECTION code_l

PUBLIC l_neg_64_mhl

EXTERN l_cpl_64_mhl

l_neg_64_mhl:

   ; negate 64-bit number at address hl
   ;
   ; enter : hl = longlong *
   ;
   ; exit  : *longlong = -longlong
   ;
   ; uses  : af, hl

   push hl
   call l_cpl_64_mhl
   pop hl
   
   inc (hl)
   ret nz
   inc hl

   inc (hl)
   ret nz
   inc hl

   inc (hl)
   ret nz
   inc hl

   inc (hl)
   ret nz
   inc hl

   inc (hl)
   ret nz
   inc hl

   inc (hl)
   ret nz
   inc hl

   inc (hl)
   ret nz
   inc hl

   inc (hl)
   ret
