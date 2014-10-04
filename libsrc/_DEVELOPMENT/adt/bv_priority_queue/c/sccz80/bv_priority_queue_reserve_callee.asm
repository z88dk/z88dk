
; int bv_priority_queue_reserve(bv_priority_queue_t *q, size_t n)

SECTION seg_code_bv_priority_queue

PUBLIC bv_priority_queue_reserve_callee

bv_priority_queue_reserve_callee:

   pop hl
   pop bc
   ex (sp),hl

   INCLUDE "adt/bv_priority_queue/z80/asm_bv_priority_queue_reserve.asm"
