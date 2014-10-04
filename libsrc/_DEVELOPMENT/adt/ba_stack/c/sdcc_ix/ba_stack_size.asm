
; size_t ba_stack_size(ba_stack_t *s)

SECTION seg_code_ba_stack

PUBLIC _ba_stack_size

EXTERN _b_array_size

defc _ba_stack_size = _b_array_size

INCLUDE "adt/ba_stack/z80/asm_ba_stack_size.asm"
