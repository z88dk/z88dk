
; int wa_stack_empty(wa_stack_t *s)

XDEF _wa_stack_empty

LIB _w_array_empty

_wa_stack_empty:

   jp _w_array_empty

   INCLUDE "adt/wa_stack/z80/asm_wa_stack_empty.asm"
