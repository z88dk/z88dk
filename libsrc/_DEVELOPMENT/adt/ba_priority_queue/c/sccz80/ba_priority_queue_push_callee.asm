
; int ba_priority_queue_push(ba_priority_queue_t *q, int c)

SECTION seg_code_ba_priority_queue

PUBLIC ba_priority_queue_push_callee

ba_priority_queue_push_callee:

   pop hl
   pop bc
   ex (sp),hl
   
   INCLUDE "adt/ba_priority_queue/z80/asm_ba_priority_queue_push.asm"
