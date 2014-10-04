
; int wa_priority_queue_empty(wa_priority_queue_t *q)

SECTION seg_code_wa_priority_queue

PUBLIC wa_priority_queue_empty

defc wa_priority_queue_empty = asm_wa_priority_queue_empty

INCLUDE "adt/wa_priority_queue/z80/asm_wa_priority_queue_empty.asm"
