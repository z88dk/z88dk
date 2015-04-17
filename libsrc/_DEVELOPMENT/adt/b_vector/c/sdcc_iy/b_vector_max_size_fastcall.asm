
; void *b_vector_max_size_fastcall(b_vector_t *v)

SECTION code_adt_b_vector

PUBLIC _b_vector_max_size_fastcall

defc _b_vector_max_size_fastcall = asm_b_vector_max_size

INCLUDE "adt/b_vector/z80/asm_b_vector_max_size.asm"
