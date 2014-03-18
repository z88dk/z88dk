
; ba_stack_t *ba_stack_init(void *p, void *data, size_t capacity)

XDEF ba_stack_init_callee

LIB b_array_init_callee

defc ba_stack_init_callee = b_array_init_callee

INCLUDE "../../z80/asm_ba_stack_init.asm"
