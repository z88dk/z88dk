
; int bv_stack_push(bv_stack_t *s, int c)

PUBLIC _bv_stack_push

EXTERN _b_vector_append

_bv_stack_push:

   jp _b_vector_append

   INCLUDE "adt/bv_stack/z80/asm_bv_stack_push.asm"
