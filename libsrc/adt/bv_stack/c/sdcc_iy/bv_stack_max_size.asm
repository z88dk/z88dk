
; size_t bv_stack_max_size(bv_stack_t *s)

SECTION code_clib
SECTION code_adt_bv_stack

PUBLIC _bv_stack_max_size

EXTERN _b_vector_max_size

defc _bv_stack_max_size = _b_vector_max_size
