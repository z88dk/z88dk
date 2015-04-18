
; int p_stack_empty_fastcall(p_stack_t *s)

SECTION code_adt_p_stack

PUBLIC _p_stack_empty_fastcall

defc _p_stack_empty_fastcall = asm_p_stack_empty

INCLUDE "adt/p_stack/z80/asm_p_stack_empty.asm"
