
; void *b_vector_append_block(b_vector_t *v, size_t n)

PUBLIC _b_vector_append_block

_b_vector_append_block:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   INCLUDE "adt/b_vector/z80/asm_b_vector_append_block.asm"
