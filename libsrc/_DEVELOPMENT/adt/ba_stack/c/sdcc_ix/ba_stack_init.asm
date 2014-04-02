
; ba_stack_t *ba_stack_init(void *p, void *data, size_t capacity)

XDEF _ba_stack_init

LIB _b_array_init

_ba_stack_init:

   jp _b_array_init

   INCLUDE "adt/ba_stack/z80/asm_ba_stack_init.asm"
