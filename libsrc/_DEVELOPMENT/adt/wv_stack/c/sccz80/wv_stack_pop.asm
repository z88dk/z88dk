
; void *wv_stack_pop(wv_stack_t *s)

SECTION seg_code_wv_stack

PUBLIC wv_stack_pop

defc wv_stack_pop = asm_wv_stack_pop

INCLUDE "adt/wv_stack/z80/asm_wv_stack_pop.asm"
