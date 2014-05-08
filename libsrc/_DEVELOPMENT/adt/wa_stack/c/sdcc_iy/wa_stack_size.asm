
; size_t wa_stack_size(wa_stack_t *s)

PUBLIC _wa_stack_size

EXTERN _w_array_size

_wa_stack_size:

   jp _w_array_size

   INCLUDE "adt/wa_stack/z80/asm_wa_stack_size.asm"
