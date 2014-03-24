
; ba_stack_t *ba_stack_init(void *p, void *data, size_t capacity)

XDEF ba_stack_init_callee

LIB b_array_init_callee

;defc ba_stack_init_callee = b_array_init_callee

ba_stack_init_callee:

   jp b_array_init_callee

INCLUDE "adt/ba_stack/z80/asm_ba_stack_init.asm"
