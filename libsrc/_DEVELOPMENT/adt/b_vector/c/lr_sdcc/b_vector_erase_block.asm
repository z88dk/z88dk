
; size_t b_vector_erase_block(b_vector_t *v, size_t idx, size_t n)

XDEF b_vector_erase_block

b_vector_erase_block:

   pop af
   pop de
   pop bc
   pop hl
   
   push hl
   push bc
   push de
   push af
   
   INCLUDE "../../z80/asm_b_vector_erase_block.asm"
