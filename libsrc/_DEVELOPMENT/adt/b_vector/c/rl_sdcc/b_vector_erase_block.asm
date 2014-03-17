
; size_t b_vector_erase_block(b_vector_t *v, size_t idx, size_t n)

XDEF b_vector_erase_block

LIB b_array_erase_block

defc b_vector_erase_block = b_array_erase_block

INCLUDE "../../z80/asm_b_vector_erase_block.asm"
