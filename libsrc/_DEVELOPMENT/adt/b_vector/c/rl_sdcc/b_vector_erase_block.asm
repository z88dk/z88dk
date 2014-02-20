
; size_t b_vector_erase_block(b_vector_t *v, size_t idx, size_t n)

XDEF b_vector_erase_block

b_vector_erase_block:

   pop af
   pop hl
   pop bc
   pop de
   
   push de
   push bc
   push hl
   push af
   
   INCLUDE "../../z80/asm_b_vector_erase_block.asm"
