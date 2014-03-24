
; int bv_stack_top(bv_stack_t *s)

XDEF bv_stack_top

;defc bv_stack_top = asm_bv_stack_top

bv_stack_top:

   INCLUDE "adt/bv_stack/z80/asm_bv_stack_top.asm"
