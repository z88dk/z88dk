
; int b_vector_at(b_vector_t *v, size_t idx)

SECTION seg_code_b_vector

PUBLIC _b_vector_at

EXTERN _b_array_at

defc _b_vector_at = _b_array_at

INCLUDE "adt/b_vector/z80/asm_b_vector_at.asm"
