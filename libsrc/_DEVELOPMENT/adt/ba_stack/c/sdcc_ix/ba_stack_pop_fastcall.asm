
; int ba_stack_pop_fastcall(ba_stack_t *s)

SECTION code_adt_ba_stack

PUBLIC _ba_stack_pop_fastcall

defc _ba_stack_pop_fastcall = asm_ba_stack_pop

INCLUDE "adt/ba_stack/z80/asm_ba_stack_pop.asm"
