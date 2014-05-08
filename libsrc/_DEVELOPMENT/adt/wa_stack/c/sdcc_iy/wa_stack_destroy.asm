
; void wa_stack_destroy(wa_stack_t *s)

PUBLIC _wa_stack_destroy

EXTERN _w_array_destroy

_wa_stack_destroy:

   jp _w_array_destroy

   INCLUDE "adt/wa_stack/z80/asm_wa_stack_destroy.asm"
