
; int bv_stack_push(bv_stack_t *s, int c)

SECTION code_clib
SECTION code_adt_bv_stack

PUBLIC _bv_stack_push

EXTERN _b_vector_append

defc _bv_stack_push = _b_vector_append
