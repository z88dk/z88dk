

SECTION code_l_clang

PUBLIC __srems

EXTERN l_divs_16_16x16

; hl = hl / bc 
__srems:
   push de
   ld de,bc
   call l_divs_16_16x16
   ex de,hl
   pop de
   ret
