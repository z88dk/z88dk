
; void ba_stack_clear(ba_stack_t *s)

SECTION code_adt_ba_stack

PUBLIC _ba_stack_clear

EXTERN _b_array_clear

defc _ba_stack_clear = _b_array_clear

INCLUDE "adt/ba_stack/z80/asm_ba_stack_clear.asm"
