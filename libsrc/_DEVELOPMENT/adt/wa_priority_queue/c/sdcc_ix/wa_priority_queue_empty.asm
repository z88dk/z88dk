
; int wa_priority_queue_empty(wa_priority_queue_t *q)

SECTION seg_code_wa_priority_queue

PUBLIC _wa_priority_queue_empty

EXTERN _ba_priority_queue_empty

defc _wa_priority_queue_empty = _ba_priority_queue_empty

INCLUDE "adt/wa_priority_queue/z80/asm_wa_priority_queue_empty.asm"
