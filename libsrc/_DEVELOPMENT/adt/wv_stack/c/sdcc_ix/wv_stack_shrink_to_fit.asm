
; int wv_stack_shrink_to_fit(wv_stack_t *s)

SECTION code_clib
SECTION code_adt_wv_stack

PUBLIC _wv_stack_shrink_to_fit

EXTERN _b_vector_shrink_to_fit

defc _wv_stack_shrink_to_fit = _b_vector_shrink_to_fit
