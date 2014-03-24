
; void *wv_stack_pop(wv_stack_t *s)

XDEF wv_stack_pop

LIB w_array_pop_back

defc wv_stack_pop = w_array_pop_back

INCLUDE "adt/wv_stack/z80/asm_wv_stack_pop.asm"
