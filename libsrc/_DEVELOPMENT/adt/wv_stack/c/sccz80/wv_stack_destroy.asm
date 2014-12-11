
; void wv_stack_destroy(wv_stack_t *s)

SECTION code_adt_wv_stack

PUBLIC wv_stack_destroy

defc wv_stack_destroy = asm_wv_stack_destroy

INCLUDE "adt/wv_stack/z80/asm_wv_stack_destroy.asm"
