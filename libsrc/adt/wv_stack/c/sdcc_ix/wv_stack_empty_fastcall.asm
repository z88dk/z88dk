
; int wv_stack_empty_fastcall(wv_stack_t *s)

SECTION code_clib
SECTION code_adt_wv_stack

PUBLIC _wv_stack_empty_fastcall

EXTERN asm_wv_stack_empty

defc _wv_stack_empty_fastcall = asm_wv_stack_empty
