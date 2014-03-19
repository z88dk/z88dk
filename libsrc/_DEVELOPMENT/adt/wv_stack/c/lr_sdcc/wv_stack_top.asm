
; void *wv_stack_top(wv_stack_t *s)

XDEF wv_stack_top

LIB w_array_back

defc wv_stack_top = w_array_back

INCLUDE "../../z80/asm_wv_stack_top.asm"
