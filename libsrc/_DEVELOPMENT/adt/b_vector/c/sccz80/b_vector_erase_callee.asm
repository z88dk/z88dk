
; size_t b_vector_erase(b_vector_t *v, size_t idx)

SECTION seg_code_b_vector

PUBLIC b_vector_erase_callee

EXTERN b_array_erase_callee

defc b_vector_erase_callee = b_array_erase_callee

INCLUDE "adt/b_vector/z80/asm_b_vector_erase.asm"
