
; int bv_stack_empty(bv_stack_t *s)

SECTION code_clib
SECTION code_adt_bv_stack

PUBLIC _bv_stack_empty

EXTERN _b_vector_empty

defc _bv_stack_empty = _b_vector_empty
