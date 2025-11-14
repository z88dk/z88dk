
; int ba_stack_top(ba_stack_t *s)

SECTION code_clib
SECTION code_adt_ba_stack

PUBLIC _ba_stack_top

EXTERN _b_array_back

defc _ba_stack_top = _b_array_back
