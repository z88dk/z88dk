
; int ba_stack_empty(ba_stack_t *s)

SECTION code_clib
SECTION code_adt_ba_stack

PUBLIC _ba_stack_empty

EXTERN _b_array_empty

defc _ba_stack_empty = _b_array_empty
