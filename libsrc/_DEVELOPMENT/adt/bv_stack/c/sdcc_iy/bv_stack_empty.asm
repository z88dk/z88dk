
; int bv_stack_empty(bv_stack_t *s)

XDEF _bv_stack_empty

LIB _b_vector_empty

_bv_stack_empty:

   jp _b_vector_empty

   INCLUDE "adt/bv_stack/z80/asm_bv_stack_empty.asm"
