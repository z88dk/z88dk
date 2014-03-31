
; int wa_stack_empty(wa_stack_t *s)

XDEF wa_stack_empty

LIB w_array_empty

wa_stack_empty:

   jp w_array_empty

   INCLUDE "adt/wa_stack/z80/asm_wa_stack_empty.asm"
