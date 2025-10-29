
; int wv_stack_shrink_to_fit_fastcall(wv_stack_t *s)

SECTION code_clib
SECTION code_adt_wv_stack

PUBLIC _wv_stack_shrink_to_fit_fastcall

EXTERN asm_wv_stack_shrink_to_fit

defc _wv_stack_shrink_to_fit_fastcall = asm_wv_stack_shrink_to_fit
