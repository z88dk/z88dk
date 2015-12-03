
; ba_stack_t *ba_stack_init(void *p, void *data, size_t capacity)

SECTION code_clib
SECTION code_adt_ba_stack

PUBLIC ba_stack_init

EXTERN b_array_init

defc ba_stack_init = b_array_init
