
; void *b_vector_data(b_vector_t *v)

SECTION seg_code_b_vector

PUBLIC _b_vector_data

EXTERN _b_array_data

defc _b_vector_data = _b_array_data

INCLUDE "adt/b_vector/z80/asm_b_vector_data.asm"
