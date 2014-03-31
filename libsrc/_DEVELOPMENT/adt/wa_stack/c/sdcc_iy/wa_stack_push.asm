
; int wa_stack_push(wa_stack_t *s, void *item)

XDEF wa_stack_push

LIB w_array_append

wa_stack_push:

   jp w_array_append

   INCLUDE "adt/wa_stack/z80/asm_wa_stack_push.asm"
