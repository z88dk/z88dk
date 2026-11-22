
; void wv_stack_destroy_fastcall(wv_stack_t *s)

SECTION code_clib
SECTION code_adt_wv_stack

PUBLIC _wv_stack_destroy_fastcall

EXTERN asm_wv_stack_destroy

defc _wv_stack_destroy_fastcall = asm_wv_stack_destroy
