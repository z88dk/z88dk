
; void *p_stack_pop_fastcall(p_stack_t *s)

SECTION code_clib
SECTION code_adt_p_stack

PUBLIC _p_stack_pop_fastcall

EXTERN asm_p_stack_pop

defc _p_stack_pop_fastcall = asm_p_stack_pop
