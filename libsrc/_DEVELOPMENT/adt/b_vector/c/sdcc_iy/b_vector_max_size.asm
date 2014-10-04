
; void *b_vector_max_size(b_vector_t *v)

SECTION seg_code_b_vector

PUBLIC _b_vector_max_size

_b_vector_max_size:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_b_vector_max_size

   INCLUDE "adt/b_vector/z80/asm_b_vector_max_size.asm"
