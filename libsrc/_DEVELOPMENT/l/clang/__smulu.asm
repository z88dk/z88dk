
SECTION code_l_clang

PUBLIC __smulu

EXTERN l_mulu_16_16x16

; hl =  hl * bc
__smulu:
   push de
   ld de,bc
   call l_mulu_16_16x16
   pop de
   ret
