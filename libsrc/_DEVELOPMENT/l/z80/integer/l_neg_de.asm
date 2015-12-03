
SECTION code_clib
SECTION code_l

PUBLIC l_neg_de

l_neg_de:

   ; negate de
   ;
   ; enter : de = int
   ;
   ; exit  : de = -de
   ;
   ; uses  : af, de, carry unaffected

   ld a,e
   cpl 
   ld e,a
   
   ld a,d
   cpl
   ld d,a
   
   inc de
   ret
