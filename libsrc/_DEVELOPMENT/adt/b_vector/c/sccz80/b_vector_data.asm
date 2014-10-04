
; void *b_vector_data(b_vector_t *v)

SECTION seg_code_b_vector

PUBLIC b_vector_data

defc b_vector_data = asm_b_vector_data

INCLUDE "adt/b_vector/z80/asm_b_vector_data.asm"
