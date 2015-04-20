
; void wa_priority_queue_clear_fastcall(wa_priority_queue_t *q)

SECTION code_adt_wa_priority_queue

PUBLIC _wa_priority_queue_clear_fastcall

defc _wa_priority_queue_clear_fastcall = asm_wa_priority_queue_clear

INCLUDE "adt/wa_priority_queue/z80/asm_wa_priority_queue_clear.asm"
