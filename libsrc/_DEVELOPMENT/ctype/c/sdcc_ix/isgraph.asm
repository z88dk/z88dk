
; int isgraph(int c)

SECTION seg_code_ctype

PUBLIC _isgraph

EXTERN asm_isgraph, error_zc

_isgraph:

   pop af
   pop hl
   
   push hl
   push af

   inc h
   dec h
   jp nz, error_zc

   ld a,l
   call asm_isgraph
   
   ld l,h
   ret c
   
   inc l
   ret
