
; int wv_stack_empty(wv_stack_t *s)

SECTION code_adt_wv_stack

PUBLIC _wv_stack_empty

EXTERN _w_vector_empty

defc _wv_stack_empty = _w_vector_empty

INCLUDE "adt/wv_stack/z80/asm_wv_stack_empty.asm"
