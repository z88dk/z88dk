

SECTION code_l_clang

PUBLIC __sdivs

EXTERN l_divs_16_16x16

; hl = hl / bc 
__sdivs:
   push de
   ld de,bc
   call l_divs_16_16x16
   pop de
   ret
