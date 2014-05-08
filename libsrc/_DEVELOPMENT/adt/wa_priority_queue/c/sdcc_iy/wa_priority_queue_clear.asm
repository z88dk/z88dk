
; void wa_priority_queue_clear(wa_priority_queue_t *q)

PUBLIC _wa_priority_queue_clear

EXTERN _ba_priority_queue_clear

_wa_priority_queue_clear:

   jp _ba_priority_queue_clear

   INCLUDE "adt/wa_priority_queue/z80/asm_wa_priority_queue_clear.asm"
