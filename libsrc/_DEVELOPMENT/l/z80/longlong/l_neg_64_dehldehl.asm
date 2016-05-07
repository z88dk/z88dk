
SECTION code_clib
SECTION code_l

PUBLIC l_neg_64_dehldehl

EXTERN l_cpl_64_dehldehl, l_inc_64_dehldehl
   
l_neg_64_dehldehl:

   ; negate dehl'dehl
   ;
   ; enter : dehl'dehl = longlong
   ;
   ; exit  : dehl'dehl = -longlong
   ;
   ; uses  : af, de, hl, de', hl', carry unaffected
   
   call l_cpl_64_dehldehl
   jp l_inc_64_dehldehl
