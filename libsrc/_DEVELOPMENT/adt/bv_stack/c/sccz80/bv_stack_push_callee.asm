
; int bv_stack_push(bv_stack_t *s, int c)

SECTION code_clib
SECTION code_adt_bv_stack

PUBLIC bv_stack_push_callee

EXTERN b_vector_append_callee

defc bv_stack_push_callee = b_vector_append_callee

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _bv_stack_push_callee
defc _bv_stack_push_callee = bv_stack_push_callee
ENDIF

