
; void wa_stack_clear(wa_stack_t *s)

SECTION code_clib
SECTION code_adt_wa_stack

PUBLIC _wa_stack_clear

EXTERN _w_array_clear

defc _wa_stack_clear = _w_array_clear
