
; int bv_priority_queue_top_fastcall(bv_priority_queue_t *q)

SECTION code_adt_bv_priority_queue

PUBLIC _bv_priority_queue_top_fastcall

defc _bv_priority_queue_top_fastcall = asm_bv_priority_queue_top

INCLUDE "adt/bv_priority_queue/z80/asm_bv_priority_queue_top.asm"
