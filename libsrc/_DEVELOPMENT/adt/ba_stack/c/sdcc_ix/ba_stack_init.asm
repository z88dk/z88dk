
; ba_stack_t *ba_stack_init(void *p, void *data, size_t capacity)

XDEF ba_stack_init

LIB b_array_init

ba_stack_init:

   jp b_array_init

   INCLUDE "adt/ba_stack/asm_ba_stack_init.asm"
