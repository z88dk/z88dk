
; int wa_stack_push(wa_stack_t *s, void *item)

SECTION code_clib
SECTION code_adt_wa_stack

PUBLIC wa_stack_push_callee

EXTERN w_array_append_callee

defc wa_stack_push_callee = w_array_append_callee
