
; int bv_stack_shrink_to_fit(bv_stack_t *s)

SECTION code_clib
SECTION code_adt_bv_stack

PUBLIC _bv_stack_shrink_to_fit

EXTERN _b_vector_shrink_to_fit

defc _bv_stack_shrink_to_fit = _b_vector_shrink_to_fit
