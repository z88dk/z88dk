
; void *wv_stack_pop(wv_stack_t *s)

SECTION code_adt_wv_stack

PUBLIC _wv_stack_pop

EXTERN _w_array_pop_back

defc _wv_stack_pop = _w_array_pop_back

INCLUDE "adt/wv_stack/z80/asm_wv_stack_pop.asm"
