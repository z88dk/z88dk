
; ba_stack_t *ba_stack_init(void *p, void *data, size_t capacity)

SECTION seg_code_ba_stack

PUBLIC _ba_stack_init

EXTERN _b_array_init

defc _ba_stack_init = _b_array_init

INCLUDE "adt/ba_stack/z80/asm_ba_stack_init.asm"
