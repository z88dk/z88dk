
; void ba_stack_destroy(ba_stack_t *s)

SECTION seg_code_ba_stack

PUBLIC _ba_stack_destroy

EXTERN _b_array_destroy

defc _ba_stack_destroy = _b_array_destroy

INCLUDE "adt/ba_stack/z80/asm_ba_stack_destroy.asm"
