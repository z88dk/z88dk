
; size_t bv_stack_size(bv_stack_t *s)

XDEF bv_stack_size

;defc bv_stack_size = asm_bv_stack_size

bv_stack_size:

   INCLUDE "adt/bv_stack/z80/asm_bv_stack_size.asm"
