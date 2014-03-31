
; int bv_stack_push(bv_stack_t *s, int c)

XDEF bv_stack_push

LIB b_vector_append

bv_stack_push:

   jp b_vector_append

   INCLUDE "adt/bv_stack/z80/asm_bv_stack_push.asm"
