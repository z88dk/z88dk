
; void *wa_stack_top(wa_stack_t *s)

SECTION code_clib
SECTION code_adt_wa_stack

PUBLIC _wa_stack_top

EXTERN _w_array_back

defc _wa_stack_top = _w_array_back
