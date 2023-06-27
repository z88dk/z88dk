
SECTION code_l_clang

PUBLIC __lmulu

EXTERN l_mulu_32_32x32

; dehl =  dehl * iybc
__lmulu:
   push bc
   push iy
   exx
   pop de
   pop hl
   call l_mulu_32_32x32
   ret
