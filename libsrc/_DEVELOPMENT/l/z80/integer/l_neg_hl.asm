
XLIB l_neg_hl

LIB _l_neg_hl

l_neg_hl:

   jp _l_neg_hl

;defc l_neg_hl = _l_neg_hl

   ; negate hl
   ;
   ; enter : hl = int
   ;
   ; exit  : hl = -hl
   ;
   ; uses  : af, hl, carry unaffected
   
