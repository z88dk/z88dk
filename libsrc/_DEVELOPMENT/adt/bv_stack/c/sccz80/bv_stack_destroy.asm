
; void bv_stack_destroy(bv_stack_t *s)

SECTION seg_code_bv_stack

PUBLIC bv_stack_destroy

defc bv_stack_destroy = asm_bv_stack_destroy

INCLUDE "adt/bv_stack/z80/asm_bv_stack_destroy.asm"
