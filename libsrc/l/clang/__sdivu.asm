

SECTION code_l_clang

PUBLIC __sdivu

EXTERN l_divu_16_16x16

; hl = hl / bc 
__sdivu:
   push de
   ld de,bc
   call l_divu_16_16x16
   pop de
   ret
