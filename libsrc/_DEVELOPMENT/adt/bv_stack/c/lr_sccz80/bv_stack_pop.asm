
; int bv_stack_pop(bv_stack_t *s)

PUBLIC bv_stack_pop

;defc bv_stack_pop = asm_bv_stack_pop

bv_stack_pop:

   INCLUDE "adt/bv_stack/z80/asm_bv_stack_pop.asm"
