
; size_t wa_stack_capacity(wa_stack_t *s)

XDEF wa_stack_capacity

LIB w_array_capacity

wa_stack_capacity:

   jp w_array_capacity

   INCLUDE "adt/wa_stack/z80/asm_wa_stack_capacity.asm"
