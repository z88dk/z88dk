
; int wv_stack_shrink_to_fit(wv_stack_t *s)

SECTION code_clib
SECTION code_adt_wv_stack

PUBLIC wv_stack_shrink_to_fit

EXTERN asm_wv_stack_shrink_to_fit

defc wv_stack_shrink_to_fit = asm_wv_stack_shrink_to_fit
