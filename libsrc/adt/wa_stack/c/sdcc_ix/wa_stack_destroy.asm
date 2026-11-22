
; void wa_stack_destroy(wa_stack_t *s)

SECTION code_clib
SECTION code_adt_wa_stack

PUBLIC _wa_stack_destroy

EXTERN _w_array_destroy

defc _wa_stack_destroy = _w_array_destroy
