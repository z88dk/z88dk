
; size_t wa_stack_capacity(wa_stack_t *s)

XDEF _wa_stack_capacity

LIB _w_array_capacity

_wa_stack_capacity:

   jp _w_array_capacity

   INCLUDE "adt/wa_stack/z80/asm_wa_stack_capacity.asm"
