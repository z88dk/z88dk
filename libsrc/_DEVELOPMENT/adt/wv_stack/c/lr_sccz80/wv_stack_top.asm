
; void *wv_stack_top(wv_stack_t *s)

XDEF wv_stack_top

defc wv_stack_top = asm_wv_stack_top

INCLUDE "../../z80/asm_wv_stack_top.asm"
