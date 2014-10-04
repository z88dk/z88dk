
; int ba_stack_push(ba_stack_t *s, int c)

SECTION seg_code_ba_stack

PUBLIC _ba_stack_push

EXTERN _b_array_append

defc _ba_stack_push = _b_array_append

INCLUDE "adt/ba_stack/z80/asm_ba_stack_push.asm"
