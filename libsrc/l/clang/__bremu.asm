

SECTION code_l_clang

PUBLIC __bremu

EXTERN l_divu_16_16x16

; a = a / c
__bremu:
   push de
   ld e,c
   ld d,0
   ld l,a
   ld h,0
   call l_divu_16_16x16
   ld   a,l
   pop de
   ret
