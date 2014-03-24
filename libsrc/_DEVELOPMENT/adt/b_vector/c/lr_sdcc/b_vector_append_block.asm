
; void *b_vector_append_block(b_vector_t *v, size_t n)

XDEF b_vector_append_block

b_vector_append_block:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   INCLUDE "adt/b_vector/z80/asm_b_vector_append_block.asm"

