
; wv_stack_t *wv_stack_init(void *p, size_t capacity, size_t max_size)

XDEF wv_stack_init

LIB w_vector_init

defc wv_stack_init = w_vector_init

INCLUDE "../../z80/asm_wv_stack_init.asm"
