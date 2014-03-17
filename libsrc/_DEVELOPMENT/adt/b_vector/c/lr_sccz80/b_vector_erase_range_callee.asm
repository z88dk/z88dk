
; size_t b_vector_erase_range(b_vector_t *v, size_t idx_first, size_t idx_last)

XDEF b_vector_erase_range_callee

LIB b_array_erase_range_callee

defc b_vector_erase_range_callee = b_array_erase_range_callee

INCLUDE "../../z80/asm_b_vector_erase_range.asm"
