
; int ba_stack_push(ba_stack_t *s, int c)

SECTION code_clib
SECTION code_adt_ba_stack

PUBLIC _ba_stack_push

EXTERN _b_array_append

defc _ba_stack_push = _b_array_append
