
SECTION code_l_clang

PUBLIC __ldivs
PUBLIC __lrems

EXTERN l_divs_32_32x32


__lrems:
  and a
  jr common
; dehl =  dehl / iybc
__ldivs:
   scf
common:

   ; dehl  = dividend
   ; iybc = divisor
   push iy
   push bc
   exx
   pop hl
   pop de
   jp c,l_divs_32_32x32
   call l_divs_32_32x32
   exx
   ret