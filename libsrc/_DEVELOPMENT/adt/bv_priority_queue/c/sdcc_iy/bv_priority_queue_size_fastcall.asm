
; size_t bv_priority_queue_size_fastcall(bv_priority_queue_t *q)

SECTION code_adt_bv_priority_queue

PUBLIC _bv_priority_queue_size_fastcall

defc _bv_priority_queue_size = asm_bv_priority_queue_size

INCLUDE "adt/bv_priority_queue/z80/asm_bv_priority_queue_size.asm"
