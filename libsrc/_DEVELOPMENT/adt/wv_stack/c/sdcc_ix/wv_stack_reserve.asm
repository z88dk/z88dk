
; int wv_stack_reserve(wv_stack_t *s, size_t n)

SECTION seg_code_wv_stack

PUBLIC _wv_stack_reserve

EXTERN _w_vector_reserve

defc _wv_stack_reserve = _w_vector_reserve

INCLUDE "adt/wv_stack/z80/asm_wv_stack_reserve.asm"
