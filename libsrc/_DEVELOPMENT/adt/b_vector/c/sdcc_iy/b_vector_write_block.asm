
; size_t b_vector_write_block(void *src, size_t n, b_vector_t *v, size_t idx)

XDEF _b_vector_write_block

_b_vector_write_block:

   pop af
   exx
   pop hl
   exx
   pop de
   pop hl
   pop bc
   
   push bc
   push hl
   push de
   exx
   push hl
   exx
   push af

   INCLUDE "adt/b_vector/z80/asm_b_vector_write_block.asm"
