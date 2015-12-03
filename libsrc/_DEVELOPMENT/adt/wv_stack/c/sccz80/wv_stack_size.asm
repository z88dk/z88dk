
; size_t wv_stack_size(wv_stack_t *s)

SECTION code_clib
SECTION code_adt_wv_stack

PUBLIC wv_stack_size

EXTERN asm_wv_stack_size

defc wv_stack_size = asm_wv_stack_size
