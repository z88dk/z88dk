
; void *p_stack_pop_fastcall(p_stack_t *s)

SECTION code_adt_p_stack

PUBLIC _p_stack_pop_fastcall

defc _p_stack_pop_fastcall = asm_p_stack_pop

INCLUDE "adt/p_stack/z80/asm_p_stack_pop.asm"
