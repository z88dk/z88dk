
; int bv_stack_push(bv_stack_t *s, int c)

SECTION seg_code_bv_stack

PUBLIC bv_stack_push

EXTERN b_vector_append

defc bv_stack_push = b_vector_append
