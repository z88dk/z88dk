
; size_t b_vector_erase_range(b_vector_t *v, size_t idx_first, size_t idx_last)

XDEF b_vector_erase_range

LIB b_array_erase_range

defc b_vector_erase_range = b_array_erase_range

INCLUDE "adt/b_vector/z80/asm_b_vector_erase_range.asm"
