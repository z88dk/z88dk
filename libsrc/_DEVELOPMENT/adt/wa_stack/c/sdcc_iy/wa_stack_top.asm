
; void *wa_stack_top(wa_stack_t *s)

XDEF wa_stack_top

LIB w_array_back

wa_stack_top:

   jp w_array_back

   INCLUDE "adt/wa_stack/z80/asm_wa_stack_top.asm"
