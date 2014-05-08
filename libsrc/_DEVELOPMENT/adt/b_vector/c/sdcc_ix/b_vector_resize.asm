
; int b_vector_resize(b_vector_t *v, size_t n)

PUBLIC _b_vector_resize

_b_vector_resize:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   INCLUDE "adt/b_vector/z80/asm_b_vector_resize.asm"
