
; void bv_priority_queue_destroy_fastcall(bv_priority_queue_t *q)

SECTION code_adt_bv_priority_queue

PUBLIC _bv_priority_queue_destroy_fastcall

_bv_priority_queue_destroy:

   INCLUDE "adt/bv_priority_queue/z80/asm_bv_priority_queue_destroy.asm"
