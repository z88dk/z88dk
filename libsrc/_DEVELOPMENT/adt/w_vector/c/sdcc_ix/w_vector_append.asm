
; size_t w_vector_append(b_vector_t *v, void *item)

SECTION seg_code_w_vector

PUBLIC _w_vector_append

_w_vector_append:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
   
   INCLUDE "adt/w_vector/z80/asm_w_vector_append.asm"
