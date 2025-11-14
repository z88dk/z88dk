
; int wv_stack_push(wv_stack_t *s, void *item)

SECTION code_clib
SECTION code_adt_wv_stack

PUBLIC wv_stack_push_callee

EXTERN w_vector_append_callee

defc wv_stack_push_callee = w_vector_append_callee

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _wv_stack_push_callee
defc _wv_stack_push_callee = wv_stack_push_callee
ENDIF

