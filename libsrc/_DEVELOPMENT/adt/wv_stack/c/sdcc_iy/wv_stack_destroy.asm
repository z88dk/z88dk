
; void wv_stack_destroy(wv_stack_t *s)

SECTION code_adt_wv_stack

PUBLIC _wv_stack_destroy

EXTERN _w_vector_destroy

defc _wv_stack_destroy = _w_vector_destroy

INCLUDE "adt/wv_stack/z80/asm_wv_stack_destroy.asm"
