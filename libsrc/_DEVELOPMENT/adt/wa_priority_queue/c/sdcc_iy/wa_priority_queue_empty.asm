
; int wa_priority_queue_empty(wa_priority_queue_t *q)

XDEF _wa_priority_queue_empty

LIB _ba_priority_queue_empty

_wa_priority_queue_empty:

   jp _ba_priority_queue_empty

   INCLUDE "adt/wa_priority_queue/z80/asm_wa_priority_queue_empty.asm"
