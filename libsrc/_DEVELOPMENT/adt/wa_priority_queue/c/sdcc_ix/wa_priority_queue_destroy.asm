
; void wa_priority_queue_destroy(ba_priority_queue_t *q)

SECTION seg_code_wa_priority_queue

PUBLIC _wa_priority_queue_destroy

EXTERN _ba_priority_queue_destroy

defc _wa_priority_queue_destroy = _ba_priority_queue_destroy

INCLUDE "adt/wa_priority_queue/z80/asm_wa_priority_queue_destroy.asm"
