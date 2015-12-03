
; void *wa_stack_pop(wa_stack_t *s)

SECTION code_clib
SECTION code_adt_wa_stack

PUBLIC _wa_stack_pop

EXTERN _w_array_pop_back

defc _wa_stack_pop = _w_array_pop_back
