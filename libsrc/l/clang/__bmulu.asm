
SECTION code_l_clang

PUBLIC __bmulu

EXTERN l_mulu_16_8x8

; hl = b * c
__bmulu:
   push de
   ld de,bc
   call l_mulu_16_8x8
   pop de
   ret
