
; ba_stack_t *ba_stack_init(void *p, void *data, size_t capacity)

SECTION code_clib
SECTION code_adt_ba_stack

PUBLIC _ba_stack_init

EXTERN _b_array_init

defc _ba_stack_init = _b_array_init
