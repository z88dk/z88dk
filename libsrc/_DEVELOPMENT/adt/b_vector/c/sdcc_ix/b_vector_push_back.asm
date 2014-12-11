
; size_t b_vector_push_back(b_vector_t *v, int c)

SECTION code_adt_b_vector

PUBLIC _b_vector_push_back

EXTERN _b_vector_append

defc _b_vector_push_back = _b_vector_append

INCLUDE "adt/b_vector/z80/asm_b_vector_push_back.asm"
