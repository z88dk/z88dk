

SECTION code_l_clang

PUBLIC __sremu

EXTERN l_divu_16_16x16

; hl = hl / bc 
__sremu:
   push de
   ld de,bc
   call l_divu_16_16x16
   ex de,hl
   pop de
   ret
