
; ba_stack_t *ba_stack_init_callee(void *p, void *data, size_t capacity)

SECTION code_clib
SECTION code_adt_ba_stack

PUBLIC _ba_stack_init_callee

EXTERN _b_array_init_callee

defc _ba_stack_init_callee = _b_array_init_callee
