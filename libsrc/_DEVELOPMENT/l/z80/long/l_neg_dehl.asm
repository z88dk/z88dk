
PUBLIC l_neg_dehl

EXTERN _l_neg_dehl_

l_neg_dehl:

   jp _l_neg_dehl_

;defc l_neg_dehl = _l_neg_dehl

   ; negate dehl
   ;
   ; enter : dehl = long
   ;
   ; exit  : dehl = -long
   ;
   ; uses  : af, de, hl, carry unaffected
