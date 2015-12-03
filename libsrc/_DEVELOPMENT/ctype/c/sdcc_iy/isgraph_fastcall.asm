
; int isgraph_fastcall(int c)

SECTION code_clib
SECTION code_ctype

PUBLIC _isgraph

EXTERN asm_isgraph, error_zc

_isgraph_fastcall:

   inc h
   dec h
   jp nz, error_zc

   ld a,l
   call asm_isgraph
   
   ld l,h
   ret c
   
   inc l
   ret
