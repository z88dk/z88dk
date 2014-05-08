
; int wa_stack_push(wa_stack_t *s, void *item)

PUBLIC wa_stack_push

EXTERN w_array_append

;defc wa_stack_push = w_array_append

wa_stack_push:

   jp w_array_append
