
; int b_vector_shrink_to_fit(b_vector_t *v)

SECTION code_clib
SECTION code_adt_b_vector

PUBLIC b_vector_shrink_to_fit

EXTERN asm_b_vector_shrink_to_fit

defc b_vector_shrink_to_fit = asm_b_vector_shrink_to_fit
