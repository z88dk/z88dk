
; void *b_vector_max_size_fastcall(b_vector_t *v)

SECTION code_clib
SECTION code_adt_b_vector

PUBLIC _b_vector_max_size_fastcall

EXTERN asm_b_vector_max_size

defc _b_vector_max_size_fastcall = asm_b_vector_max_size
