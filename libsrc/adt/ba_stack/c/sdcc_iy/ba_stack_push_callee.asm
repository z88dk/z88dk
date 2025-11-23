
; int ba_stack_push_callee(ba_stack_t *s, int c)

SECTION code_clib
SECTION code_adt_ba_stack

PUBLIC _ba_stack_push_callee

EXTERN _b_array_append_callee

defc _ba_stack_push_callee = _b_array_append_callee
