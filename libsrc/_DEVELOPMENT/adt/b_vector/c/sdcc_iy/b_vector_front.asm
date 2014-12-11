
; int b_vector_front(b_vector_t *v)

SECTION code_adt_b_vector

PUBLIC _b_vector_front

EXTERN _b_array_front

defc _b_vector_front = _b_array_front

INCLUDE "adt/b_vector/z80/asm_b_vector_front.asm"
