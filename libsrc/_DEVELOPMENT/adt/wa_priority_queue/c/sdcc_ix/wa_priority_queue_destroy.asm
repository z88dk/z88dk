
; void wa_priority_queue_destroy(ba_priority_queue_t *q)

XDEF _wa_priority_queue_destroy

LIB _ba_priority_queue_destroy

_wa_priority_queue_destroy:

   jp _ba_priority_queue_destroy

   INCLUDE "adt/wa_priority_queue/z80/asm_wa_priority_queue_destroy.asm"
