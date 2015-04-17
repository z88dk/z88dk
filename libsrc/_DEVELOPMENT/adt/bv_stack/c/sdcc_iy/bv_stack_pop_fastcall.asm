
; int bv_stack_pop_fastcall(bv_stack_t *s)

SECTION code_adt_bv_stack

PUBLIC _bv_stack_pop_fastcall

defc _bv_stack_pop = asm_bv_stack_pop

INCLUDE "adt/bv_stack/z80/asm_bv_stack_pop.asm"
