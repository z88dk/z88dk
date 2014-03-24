
; size_t p_stack_size(p_stack_t *s)

XDEF p_stack_size

;defc p_stack_size = asm_p_stack_size

p_stack_size:

   INCLUDE "adt/p_stack/z80/asm_p_stack_size.asm"
