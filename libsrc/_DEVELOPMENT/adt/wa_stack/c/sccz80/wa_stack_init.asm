
; wa_stack_t *wa_stack_init(void *p, void *data, size_t capacity)

PUBLIC wa_stack_init

EXTERN w_array_init

;defc wa_stack_init = w_array_init

wa_stack_init:

   jp w_array_init
