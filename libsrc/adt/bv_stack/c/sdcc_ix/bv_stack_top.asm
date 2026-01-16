
; int bv_stack_top(bv_stack_t *s)

SECTION code_clib
SECTION code_adt_bv_stack

PUBLIC _bv_stack_top

EXTERN _b_array_back

defc _bv_stack_top = _b_array_back
