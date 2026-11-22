
SECTION code_l_clang

PUBLIC __ldivu
PUBLIC __lremu

EXTERN l_divu_32_32x32


__lremu:
  and a
  jr common
; dehl =  dehl / iybc
__ldivu:
   scf
common:

   ; dehl  = dividend
   ; iybc = divisor
   push iy
   push bc
   exx
   pop hl
   pop de
   jp c,l_divu_32_32x32
   call l_divu_32_32x32
   exx
   ret