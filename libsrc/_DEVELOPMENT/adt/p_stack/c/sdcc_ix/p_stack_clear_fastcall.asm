
; void p_stack_clear_fastcall(p_stack_t *s)

SECTION code_adt_p_stack

PUBLIC _p_stack_clear_fastcall

defc _p_stack_clear_fastcall = asm_p_stack_clear

INCLUDE "adt/p_stack/z80/asm_p_stack_clear.asm"
