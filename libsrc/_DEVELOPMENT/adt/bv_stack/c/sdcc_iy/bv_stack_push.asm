
; int bv_stack_push(bv_stack_t *s, int c)

SECTION seg_code_bv_stack

PUBLIC _bv_stack_push

EXTERN _b_vector_append

defc _bv_stack_push = _b_vector_append

INCLUDE "adt/bv_stack/z80/asm_bv_stack_push.asm"
