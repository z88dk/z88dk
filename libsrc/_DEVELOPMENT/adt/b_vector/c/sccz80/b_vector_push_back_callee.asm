
; size_t b_vector_push_back(b_vector_t *v, int c)

SECTION code_adt_b_vector

PUBLIC b_vector_push_back_callee

EXTERN b_vector_append_callee

defc b_vector_push_back_callee = b_vector_append_callee

INCLUDE "adt/b_vector/z80/asm_b_vector_push_back.asm"
