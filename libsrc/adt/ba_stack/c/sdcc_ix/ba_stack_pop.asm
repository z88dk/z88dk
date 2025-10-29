
; int ba_stack_pop(ba_stack_t *s)

SECTION code_clib
SECTION code_adt_ba_stack

PUBLIC _ba_stack_pop

EXTERN _b_array_pop_back

defc _ba_stack_pop = _b_array_pop_back
