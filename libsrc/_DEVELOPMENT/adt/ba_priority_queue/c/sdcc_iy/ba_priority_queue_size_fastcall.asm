
; size_t ba_priority_queue_size_fastcall(ba_priority_queue_t *q)

SECTION code_adt_ba_priority_queue

PUBLIC _ba_priority_queue_size_fastcall

defc _ba_priority_queue_size_fastcall = asm_ba_priority_queue_size

INCLUDE "adt/ba_priority_queue/z80/asm_ba_priority_queue_size.asm"
