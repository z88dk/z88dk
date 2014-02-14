
; int isgraph(int c)

XLIB isgraph

LIB asm_isgraph, error_zc

isgraph:

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
