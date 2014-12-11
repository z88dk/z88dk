
; void *b_vector_size(b_vector_t *v)

SECTION code_adt_b_vector

PUBLIC b_vector_size

defc b_vector_size = asm_b_vector_size

INCLUDE "adt/b_vector/z80/asm_b_vector_size.asm"
