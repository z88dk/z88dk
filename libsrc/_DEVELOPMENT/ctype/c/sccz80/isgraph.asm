
; int isgraph(int c)

SECTION code_clib
SECTION code_ctype

PUBLIC isgraph

EXTERN asm_isgraph, error_zc

isgraph:

   inc h
   dec h
   jp nz, error_zc

   ld a,l
   call asm_isgraph
   
   ld l,h
   ret c
   
   inc l
   ret
