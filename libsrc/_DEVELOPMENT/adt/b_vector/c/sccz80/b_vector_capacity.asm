
; size_t b_vector_capacity(b_vector_t *v)

SECTION seg_code_b_vector

PUBLIC b_vector_capacity

defc b_vector_capacity = asm_b_vector_capacity

INCLUDE "adt/b_vector/z80/asm_b_vector_capacity.asm"
