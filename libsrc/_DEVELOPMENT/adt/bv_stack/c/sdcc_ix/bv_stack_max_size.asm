
; size_t bv_stack_max_size(bv_stack_t *s)

PUBLIC _bv_stack_max_size

EXTERN _b_vector_max_size

_bv_stack_max_size:

   jp _b_vector_max_size

   INCLUDE "adt/bv_stack/z80/asm_bv_stack_max_size.asm"
