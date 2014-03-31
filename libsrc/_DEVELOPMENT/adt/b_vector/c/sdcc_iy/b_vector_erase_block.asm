
; size_t b_vector_erase_block(b_vector_t *v, size_t idx, size_t n)

XDEF b_vector_erase_block

LIB b_array_erase_block

b_vector_erase_block:

   jp b_array_erase_block

   INCLUDE "adt/b_vector/z80/asm_b_vector_erase_block.asm"
