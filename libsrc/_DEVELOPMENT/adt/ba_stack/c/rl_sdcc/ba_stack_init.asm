
; ba_stack_t *ba_stack_init(void *p, void *data, size_t capacity)

XDEF ba_stack_init

LIB b_array_init

defc ba_stack_init = b_array_init

INCLUDE "../../asm_ba_stack_init.asm"
