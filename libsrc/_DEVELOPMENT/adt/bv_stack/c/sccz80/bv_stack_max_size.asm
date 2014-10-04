
; size_t bv_stack_max_size(bv_stack_t *s)

SECTION seg_code_bv_stack

PUBLIC bv_stack_max_size

defc bv_stack_max_size = asm_bv_stack_max_size

INCLUDE "adt/bv_stack/z80/asm_bv_stack_max_size.asm"
