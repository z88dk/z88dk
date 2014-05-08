
; size_t wv_stack_capacity(wv_stack_t *s)

PUBLIC wv_stack_capacity

;defc wv_stack_capacity = asm_wv_stack_capacity

wv_stack_capacity:

   INCLUDE "adt/wv_stack/z80/asm_wv_stack_capacity.asm"
