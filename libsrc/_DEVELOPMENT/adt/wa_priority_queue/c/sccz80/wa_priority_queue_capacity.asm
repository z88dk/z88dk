
; size_t wa_priority_queue_capacity(wa_priority_queue_t *q)

SECTION seg_code_wa_priority_queue

PUBLIC wa_priority_queue_capacity

defc wa_priority_queue_capacity = asm_wa_priority_queue_capacity

INCLUDE "adt/wa_priority_queue/z80/asm_wa_priority_queue_capacity.asm"
