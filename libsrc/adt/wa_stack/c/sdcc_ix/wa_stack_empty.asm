
; int wa_stack_empty(wa_stack_t *s)

SECTION code_clib
SECTION code_adt_wa_stack

PUBLIC _wa_stack_empty

EXTERN _w_array_empty

defc _wa_stack_empty = _w_array_empty
