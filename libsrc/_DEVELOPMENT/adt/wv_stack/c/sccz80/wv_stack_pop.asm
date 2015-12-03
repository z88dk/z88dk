
; void *wv_stack_pop(wv_stack_t *s)

SECTION code_clib
SECTION code_adt_wv_stack

PUBLIC wv_stack_pop

EXTERN asm_wv_stack_pop

defc wv_stack_pop = asm_wv_stack_pop
