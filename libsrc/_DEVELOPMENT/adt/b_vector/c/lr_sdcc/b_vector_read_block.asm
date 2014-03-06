
; size_t b_vector_read_block(void *dst, size_t n, b_vector_t *v, size_t idx)

XDEF b_vector_read_block

b_vector_read_block:

   pop af
   pop bc
   pop hl
   pop de
   exx
   pop de
   
   push de
   exx
   push de
   push hl
   push bc
   push af
   
   INCLUDE "../../z80/asm_b_vector_read_block.asm"
