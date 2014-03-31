
; size_t wv_stack_max_size(wv_stack_t *s)

XDEF wv_stack_max_size

LIB w_vector_max_size

wv_stack_max_size:

   jp w_vector_max_size

   INCLUDE "adt/wv_stack/z80/asm_wv_stack_size.asm"
