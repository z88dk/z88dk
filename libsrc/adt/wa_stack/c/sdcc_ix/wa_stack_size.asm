
; size_t wa_stack_size(wa_stack_t *s)

SECTION code_clib
SECTION code_adt_wa_stack

PUBLIC _wa_stack_size

EXTERN _w_array_size

defc _wa_stack_size = _w_array_size
