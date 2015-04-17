
; void ba_priority_queue_destroy_fastcall(ba_priority_queue_t *q)

SECTION code_adt_ba_priority_queue

PUBLIC _ba_priority_queue_destroy_fastcall

_ba_priority_queue_destroy_fastcall:

   INCLUDE "adt/ba_priority_queue/z80/asm_ba_priority_queue_destroy.asm"
