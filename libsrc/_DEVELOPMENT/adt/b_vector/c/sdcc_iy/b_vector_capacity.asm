
; size_t b_vector_capacity(b_vector_t *v)

SECTION seg_code_b_vector

PUBLIC _b_vector_capacity

EXTERN _b_array_capacity

defc _b_vector_capacity = _b_array_capacity

INCLUDE "adt/b_vector/z80/asm_b_vector_capacity.asm"
