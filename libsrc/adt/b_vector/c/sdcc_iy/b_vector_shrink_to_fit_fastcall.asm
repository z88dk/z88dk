
; int b_vector_shrink_to_fit_fastcall(b_vector_t *v)

SECTION code_clib
SECTION code_adt_b_vector

PUBLIC _b_vector_shrink_to_fit_fastcall

EXTERN asm_b_vector_shrink_to_fit

defc _b_vector_shrink_to_fit_fastcall = asm_b_vector_shrink_to_fit
