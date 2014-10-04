
; void wv_stack_clear(wv_stack_t *s)

SECTION seg_code_wv_stack

PUBLIC _wv_stack_clear

EXTERN _w_vector_clear

defc _wv_stack_clear = _w_vector_clear

INCLUDE "adt/wv_stack/z80/asm_wv_stack_clear.asm"
