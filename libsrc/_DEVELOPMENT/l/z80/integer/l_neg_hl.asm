
XLIB l_neg_hl

LIB _l_neg_hl_

l_neg_hl:

   jp _l_neg_hl_

;defc l_neg_hl = _l_neg_hl

   ; negate hl
   ;
   ; enter : hl = int
   ;
   ; exit  : hl = -hl
   ;
   ; uses  : af, hl, carry unaffected
   
