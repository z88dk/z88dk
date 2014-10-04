
; int ba_stack_empty(ba_stack_t *s)

SECTION seg_code_ba_stack

PUBLIC _ba_stack_empty

EXTERN _b_array_empty

defc _ba_stack_empty = _b_array_empty

INCLUDE "adt/ba_stack/z80/asm_ba_stack_empty.asm"
