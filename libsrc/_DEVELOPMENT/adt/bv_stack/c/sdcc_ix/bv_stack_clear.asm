
; void bv_stack_clear(bv_stack_t *s)

XDEF _bv_stack_clear

LIB _b_vector_clear

_bv_stack_clear:

   jp _b_vector_clear

   INCLUDE "adt/bv_stack/z80/asm_bv_stack_clear.asm"
