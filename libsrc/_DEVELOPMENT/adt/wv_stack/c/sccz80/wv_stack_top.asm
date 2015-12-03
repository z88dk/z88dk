
; void *wv_stack_top(wv_stack_t *s)

SECTION code_clib
SECTION code_adt_wv_stack

PUBLIC wv_stack_top

EXTERN asm_wv_stack_top

defc wv_stack_top = asm_wv_stack_top
