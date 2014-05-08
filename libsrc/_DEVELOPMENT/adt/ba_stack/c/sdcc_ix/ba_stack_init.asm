
; ba_stack_t *ba_stack_init(void *p, void *data, size_t capacity)

PUBLIC _ba_stack_init

EXTERN _b_array_init

_ba_stack_init:

   jp _b_array_init

   INCLUDE "adt/ba_stack/z80/asm_ba_stack_init.asm"
