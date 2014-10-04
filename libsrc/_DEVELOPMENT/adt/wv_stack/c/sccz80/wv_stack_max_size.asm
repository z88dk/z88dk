
; size_t wv_stack_max_size(wv_stack_t *s)

SECTION seg_code_wv_stack

PUBLIC wv_stack_max_size

defc wv_stack_max_size = asm_wv_stack_size

INCLUDE "adt/wv_stack/z80/asm_wv_stack_size.asm"
