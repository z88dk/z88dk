
; size_t wv_stack_capacity(wv_stack_t *s)

SECTION seg_code_wv_stack

PUBLIC _wv_stack_capacity

EXTERN _w_vector_capacity

defc _wv_stack_capacity = _w_vector_capacity

INCLUDE "adt/wv_stack/z80/asm_wv_stack_capacity.asm"
