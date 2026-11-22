
; size_t p_stack_size_fastcall(p_stack_t *s)

SECTION code_clib
SECTION code_adt_p_stack

PUBLIC _p_stack_size_fastcall

EXTERN asm_p_stack_size

defc _p_stack_size_fastcall = asm_p_stack_size
