
; void wa_priority_queue_destroy_fastcall(ba_priority_queue_t *q)

SECTION code_adt_wa_priority_queue

PUBLIC _wa_priority_queue_destroy_fastcall

defc _wa_priority_queue_destroy_fastcall = asm_wa_priority_queue_destroy

INCLUDE "adt/wa_priority_queue/z80/asm_wa_priority_queue_destroy.asm"
