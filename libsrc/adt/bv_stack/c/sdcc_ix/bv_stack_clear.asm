
; void bv_stack_clear(bv_stack_t *s)

SECTION code_clib
SECTION code_adt_bv_stack

PUBLIC _bv_stack_clear

EXTERN _b_vector_clear

defc _bv_stack_clear = _b_vector_clear
