
; void wa_priority_queue_clear(wa_priority_queue_t *q)

XDEF wa_priority_queue_clear

LIB ba_priority_queue_clear

wa_priority_queue_clear:

   jp ba_priority_queue_clear

   INCLUDE "adt/wa_priority_queue/z80/asm_wa_priority_queue_clear.asm"
