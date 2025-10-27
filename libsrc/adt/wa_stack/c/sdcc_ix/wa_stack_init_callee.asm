
; wa_stack_t *wa_stack_init_callee(void *p, void *data, size_t capacity)

SECTION code_clib
SECTION code_adt_wa_stack

PUBLIC _wa_stack_init_callee

EXTERN _w_array_init_callee

defc _wa_stack_init_callee = _w_array_init_callee
