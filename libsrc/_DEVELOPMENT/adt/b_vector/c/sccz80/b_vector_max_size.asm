
; void *b_vector_max_size(b_vector_t *v)

SECTION seg_code_b_vector

PUBLIC b_vector_max_size

defc b_vector_max_size = asm_b_vector_max_size

INCLUDE "adt/b_vector/z80/asm_b_vector_max_size.asm"
