
; size_t wv_stack_size_fastcall(wv_stack_t *s)

SECTION code_clib
SECTION code_adt_wv_stack

PUBLIC _wv_stack_size_fastcall

EXTERN asm_wv_stack_size

defc _wv_stack_size_fastcall = asm_wv_stack_size
