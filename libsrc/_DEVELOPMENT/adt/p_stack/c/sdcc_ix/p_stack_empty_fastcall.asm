
; int p_stack_empty_fastcall(p_stack_t *s)

SECTION code_clib
SECTION code_adt_p_stack

PUBLIC _p_stack_empty_fastcall

EXTERN asm_p_stack_empty

defc _p_stack_empty_fastcall = asm_p_stack_empty
