
; int w_vector_shrink_to_fit(w_vector_t *v)

SECTION code_clib
SECTION code_adt_w_vector

PUBLIC w_vector_shrink_to_fit

EXTERN asm_w_vector_shrink_to_fit

defc w_vector_shrink_to_fit = asm_w_vector_shrink_to_fit
