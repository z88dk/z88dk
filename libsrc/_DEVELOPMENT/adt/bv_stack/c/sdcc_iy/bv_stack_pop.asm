
; int bv_stack_pop(bv_stack_t *s)

SECTION code_clib
SECTION code_adt_bv_stack

PUBLIC _bv_stack_pop

EXTERN _b_array_pop_back

defc _bv_stack_pop = _b_array_pop_back
