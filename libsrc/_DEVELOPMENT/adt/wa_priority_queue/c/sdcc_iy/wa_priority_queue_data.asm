
; void *wa_priority_queue_data(wa_priority_queue_t *q)

PUBLIC _wa_priority_queue_data

EXTERN _ba_priority_queue_data

_wa_priority_queue_data:

   jp _ba_priority_queue_data

   INCLUDE "adt/wa_priority_queue/z80/asm_wa_priority_queue_data.asm"
