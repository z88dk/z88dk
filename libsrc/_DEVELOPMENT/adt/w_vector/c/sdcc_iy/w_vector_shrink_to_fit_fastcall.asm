
; int w_vector_shrink_to_fit_fastcall(w_vector_t *v)

SECTION code_clib
SECTION code_adt_w_vector

PUBLIC _w_vector_shrink_to_fit_fastcall

EXTERN asm_w_vector_shrink_to_fit

defc _w_vector_shrink_to_fit_fastcall = asm_w_vector_shrink_to_fit
