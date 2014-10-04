
; int wa_stack_push(wa_stack_t *s, void *item)

SECTION seg_code_wa_stack

PUBLIC wa_stack_push

EXTERN w_array_append

defc wa_stack_push = w_array_append
