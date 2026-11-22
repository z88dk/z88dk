
; void *p_stack_top_fastcall(p_stack_t *s)

SECTION code_clib
SECTION code_adt_p_stack

PUBLIC _p_stack_top_fastcall

EXTERN asm_p_stack_top

defc _p_stack_top_fastcall = asm_p_stack_top
