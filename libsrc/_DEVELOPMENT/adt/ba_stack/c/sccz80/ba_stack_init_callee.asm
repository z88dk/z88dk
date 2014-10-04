
; ba_stack_t *ba_stack_init(void *p, void *data, size_t capacity)

SECTION seg_code_ba_stack

PUBLIC ba_stack_init_callee

EXTERN b_array_init_callee

defc ba_stack_init_callee = b_array_init_callee

INCLUDE "adt/ba_stack/z80/asm_ba_stack_init.asm"
