
; wa_stack_t *wa_stack_init(void *p, void *data, size_t capacity)

SECTION code_clib
SECTION code_adt_wa_stack

PUBLIC wa_stack_init_callee

EXTERN w_array_init_callee

defc wa_stack_init_callee = w_array_init_callee
