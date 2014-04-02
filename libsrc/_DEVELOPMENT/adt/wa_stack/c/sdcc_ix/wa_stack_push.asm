
; int wa_stack_push(wa_stack_t *s, void *item)

XDEF _wa_stack_push

LIB _w_array_append

_wa_stack_push:

   jp _w_array_append

   INCLUDE "adt/wa_stack/z80/asm_wa_stack_push.asm"
