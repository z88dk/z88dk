
; void *b_vector_insert_block(b_vector_t *v, size_t idx, size_t n)

XDEF b_vector_insert_block

b_vector_insert_block:

   pop af
   pop de
   pop bc
   pop hl
   
   push hl
   push bc
   push de
   push af
   
   INCLUDE "../../z80/asm_b_vector_insert_block.asm"
