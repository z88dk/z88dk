
SECTION code_clib
SECTION code_l_sdcc

PUBLIC ___mulsint2slong

EXTERN l_neg_de, l_neg_hl, l_neg_dehl
EXTERN l_mulu_32_16x16

___mulsint2slong:

   ; 16-bit multiplication, 32-bit result
   ;
   ; enter : stack = multiplicand, multiplicand, ret
   ;
   ; exit  : dehl = product

   pop af
   pop hl
   pop de

   push de
   push hl
   push af

   ; determine sign of result

   ld a,d
   xor h
   push af                  ; save flags

   ; make multiplicands positive

   bit 7,d                  ;test sign
   call NZ,l_neg_de         ;take absolute value

   bit 7,h                  ;test sign
   call NZ,l_neg_hl         ;take absolute value

   call l_mulu_32_16x16

   pop af
   ret P                    ;return if signs positive

   ; correct sign of result

   jp l_neg_dehl            ;negate result if signs different
