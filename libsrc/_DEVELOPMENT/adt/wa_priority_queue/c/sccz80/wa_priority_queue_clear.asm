
; void wa_priority_queue_clear(wa_priority_queue_t *q)

SECTION seg_code_wa_priority_queue

PUBLIC wa_priority_queue_clear

defc wa_priority_queue_clear = asm_wa_priority_queue_clear

INCLUDE "adt/wa_priority_queue/z80/asm_wa_priority_queue_clear.asm"
