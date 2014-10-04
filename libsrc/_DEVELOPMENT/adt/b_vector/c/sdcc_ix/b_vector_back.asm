
; int b_vector_back(b_vector_t *v)

SECTION seg_code_b_vector

PUBLIC _b_vector_back

EXTERN _b_array_back

defc _b_vector_back = jp _b_array_back

INCLUDE "adt/b_vector/z80/asm_b_vector_back.asm"
