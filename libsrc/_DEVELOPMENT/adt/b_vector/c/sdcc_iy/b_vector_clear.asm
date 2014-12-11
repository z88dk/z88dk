
; void b_vector_clear(b_vector_t *v)

SECTION code_adt_b_vector

PUBLIC _b_vector_clear

EXTERN _b_array_clear

defc _b_vector_clear = _b_array_clear

INCLUDE "adt/b_vector/z80/asm_b_vector_clear.asm"
