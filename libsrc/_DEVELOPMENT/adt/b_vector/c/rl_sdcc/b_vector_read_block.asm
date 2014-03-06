
; size_t b_vector_read_block(void *dst, size_t n, b_vector_t *v, size_t idx)

XDEF b_vector_read_block

b_vector_read_block:

   pop af
   pop de
   exx
   pop de
   pop hl
   pop bc
   
   push bc
   push hl
   push de
   exx
   push de
   push af
   
   exx
   
   INCLUDE "../../z80/asm_b_vector_read_block.asm"
