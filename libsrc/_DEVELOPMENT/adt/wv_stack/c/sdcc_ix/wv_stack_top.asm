
; void *wv_stack_top(wv_stack_t *s)

SECTION seg_code_wv_stack

PUBLIC _wv_stack_top

EXTERN _w_array_back

defc _wv_stack_top = _w_array_back

INCLUDE "adt/wv_stack/z80/asm_wv_stack_top.asm"
