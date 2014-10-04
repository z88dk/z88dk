
; void b_vector_empty(b_vector_t *v)

SECTION seg_code_b_vector

PUBLIC _b_vector_empty

EXTERN _b_array_empty

defc _b_vector_empty = _b_array_empty

INCLUDE "adt/b_vector/z80/asm_b_vector_empty.asm"
