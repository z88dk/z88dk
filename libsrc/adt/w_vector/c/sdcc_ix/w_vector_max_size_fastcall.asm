
; void *w_vector_max_size_fastcall(w_vector_t *v)

SECTION code_clib
SECTION code_adt_w_vector

PUBLIC _w_vector_max_size_fastcall

EXTERN asm_w_vector_max_size

defc _w_vector_max_size_fastcall = asm_w_vector_max_size
