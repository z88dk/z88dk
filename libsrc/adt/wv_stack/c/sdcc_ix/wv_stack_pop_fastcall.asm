
; void *wv_stack_pop_fastcall(wv_stack_t *s)

SECTION code_clib
SECTION code_adt_wv_stack

PUBLIC _wv_stack_pop_fastcall

EXTERN asm_wv_stack_pop

defc _wv_stack_pop_fastcall = asm_wv_stack_pop
