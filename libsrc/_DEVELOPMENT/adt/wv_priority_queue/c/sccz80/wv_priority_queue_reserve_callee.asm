
; int wv_priority_queue_reserve(wv_priority_queue_t *q, size_t n)

SECTION seg_code_wv_priority_queue

PUBLIC wv_priority_queue_reserve_callee

wv_priority_queue_reserve_callee:

   pop hl
   pop bc
   ex (sp),hl

   INCLUDE "adt/wv_priority_queue/z80/asm_wv_priority_queue_reserve.asm"
