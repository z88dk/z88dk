
; size_t wv_stack_size(wv_stack_t *s)

XDEF wv_stack_size

LIB w_vector_size

defc wv_stack_size = w_vector_size

INCLUDE "../../z80/asm_wv_stack_size.asm"
