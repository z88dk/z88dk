
; void *w_vector_pop_back(w_vector_t *v)

SECTION code_clib
SECTION code_adt_w_vector

PUBLIC w_vector_pop_back

EXTERN asm_w_vector_pop_back

defc w_vector_pop_back = asm_w_vector_pop_back
