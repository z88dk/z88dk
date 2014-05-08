
; wv_stack_t *wv_stack_init(void *p, size_t capacity, size_t max_size)

PUBLIC _wv_stack_init

EXTERN _w_vector_init

_wv_stack_init:

   jp _w_vector_init

   INCLUDE "adt/wv_stack/z80/asm_wv_stack_init.asm"
