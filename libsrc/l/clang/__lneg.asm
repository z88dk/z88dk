
SECTION code_l_clang

PUBLIC __lneg

; negate dehl
__lneg:
    push af	;TODO Necessary?
    call l_neg_dehl

    pop af
    ret

l_neg_dehl:

   ; negate dehl
   ;
   ; enter : dehl = long
   ;
   ; exit  : dehl = -long
   ;
   ; uses  : af, de, hl, carry unaffected

   ld a,l
   cpl
   ld l,a

   ld a,h
   cpl
   ld h,a

   ld a,e
   cpl
   ld e,a

   ld a,d
   cpl
   ld d,a

   inc l
   ret nz

   inc h
   ret nz

   inc de
   ret
