
; size_t wv_stack_capacity_fastcall(wv_stack_t *s)

SECTION code_clib
SECTION code_adt_wv_stack

PUBLIC _wv_stack_capacity_fastcall

EXTERN asm_wv_stack_capacity

defc _wv_stack_capacity_fastcall = asm_wv_stack_capacity
