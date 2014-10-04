
; void wa_priority_queue_destroy(ba_priority_queue_t *q)

SECTION seg_code_wa_priority_queue

PUBLIC wa_priority_queue_destroy

defc wa_priority_queue_destroy = asm_wa_priority_queue_destroy

INCLUDE "adt/wa_priority_queue/z80/asm_wa_priority_queue_destroy.asm"
