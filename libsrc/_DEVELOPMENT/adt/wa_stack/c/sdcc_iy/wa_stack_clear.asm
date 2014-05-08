
; void wa_stack_clear(wa_stack_t *s)

PUBLIC _wa_stack_clear

EXTERN _w_array_clear

_wa_stack_clear:

   jp _w_array_clear

   INCLUDE "adt/wa_stack/z80/asm_wa_stack_clear.asm"
