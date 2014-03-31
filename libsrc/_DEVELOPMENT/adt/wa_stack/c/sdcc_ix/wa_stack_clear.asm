
; void wa_stack_clear(wa_stack_t *s)

XDEF wa_stack_clear

LIB w_array_clear

wa_stack_clear:

   jp w_array_clear

   INCLUDE "adt/wa_stack/z80/asm_wa_stack_clear.asm"
