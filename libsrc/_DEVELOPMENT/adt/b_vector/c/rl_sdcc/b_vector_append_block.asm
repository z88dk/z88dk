
; void *b_vector_append_block(b_vector_t *v, size_t n)

XDEF b_vector_append_block

b_vector_append_block:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
   
   INCLUDE "../../z80/asm_b_vector_append_block.asm"
