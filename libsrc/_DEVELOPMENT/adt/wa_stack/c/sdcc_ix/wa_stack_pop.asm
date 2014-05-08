
; void *wa_stack_pop(wa_stack_t *s)

PUBLIC _wa_stack_pop

EXTERN _w_array_pop_back

_wa_stack_pop:

   jp _w_array_pop_back

   INCLUDE "adt/wa_stack/z80/asm_wa_stack_pop.asm"
