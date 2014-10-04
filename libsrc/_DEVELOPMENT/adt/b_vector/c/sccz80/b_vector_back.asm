
; int b_vector_back(b_vector_t *v)

SECTION seg_code_b_vector

PUBLIC b_vector_back

EXTERN b_array_back

defc b_vector_back = b_array_back

INCLUDE "adt/b_vector/z80/asm_b_vector_back.asm"
