
; void ba_stack_destroy(ba_stack_t *s)

SECTION code_clib
SECTION code_adt_ba_stack

PUBLIC _ba_stack_destroy

EXTERN _b_array_destroy

defc _ba_stack_destroy = _b_array_destroy
