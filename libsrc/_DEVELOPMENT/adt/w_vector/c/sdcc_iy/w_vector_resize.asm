
; int w_vector_resize(w_vector_t *v, size_t n)

SECTION code_adt_w_vector

PUBLIC _w_vector_resize

_w_vector_resize:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   INCLUDE "adt/w_vector/z80/asm_w_vector_resize.asm"
