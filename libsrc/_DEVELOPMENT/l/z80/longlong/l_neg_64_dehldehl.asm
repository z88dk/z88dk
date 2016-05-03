
SECTION code_clib
SECTION code_l

PUBLIC l_neg_64_dehldehl

EXTERN l_cpl_64_dehldehl
   
l_neg_64_dehldehl:

   ; negate dehl'dehl
   ;
   ; enter : dehl'dehl = longlong
   ;
   ; exit  : dehl'dehl = -longlong
   ;
   ; uses  : af, de, hl, de', hl', carry unaffected
   
   call l_cpl_64_dehldehl
   
   inc l
   ret nz
   
   inc h
   ret nz
   
   inc e
   ret nz
   
   inc d
   ret nz
   
   exx
   
   inc l
   jr nz, exx_ret
   
   inc h
   jr nz, exx_ret
   
   inc de

exx_ret:

   exx
   ret
