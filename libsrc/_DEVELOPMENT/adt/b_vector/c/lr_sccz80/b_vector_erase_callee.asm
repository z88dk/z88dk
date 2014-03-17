
; size_t b_vector_erase(b_vector_t *v, size_t idx)

XDEF b_vector_erase_callee

LIB b_array_erase_callee

defc b_vector_erase_callee = b_array_erase_callee

INCLUDE "../../z80/asm_b_vector_erase.asm"
