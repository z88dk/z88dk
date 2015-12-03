
; void *w_vector_max_size(w_vector_t *v)

SECTION code_clib
SECTION code_adt_w_vector

PUBLIC w_vector_max_size

EXTERN asm_w_vector_max_size

defc w_vector_max_size = asm_w_vector_max_size
