
; void wv_stack_clear_fastcall(wv_stack_t *s)

SECTION code_clib
SECTION code_adt_wv_stack

PUBLIC _wv_stack_clear_fastcall

EXTERN asm_wv_stack_clear

defc _wv_stack_clear_fastcall = asm_wv_stack_clear
