
; int wa_stack_push(wa_stack_t *s, void *item)

SECTION code_clib
SECTION code_adt_wa_stack

PUBLIC _wa_stack_push

EXTERN _w_array_append

defc _wa_stack_push = _w_array_append
