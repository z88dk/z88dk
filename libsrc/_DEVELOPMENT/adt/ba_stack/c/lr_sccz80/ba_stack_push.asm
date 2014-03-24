
; int ba_stack_push(ba_stack_t *s, int c)

XLIB ba_stack_push

LIB b_array_append

;defc ba_stack_push = b_array_append

ba_stack_push:

   jp b_array_append
