
; int wv_priority_queue_push(wv_priority_queue_t *q, void *item)

SECTION seg_code_wv_priority_queue

PUBLIC wv_priority_queue_push_callee

wv_priority_queue_push_callee:

   pop hl
   pop bc
   ex (sp),hl
   
   INCLUDE "adt/wv_priority_queue/z80/asm_wv_priority_queue_push.asm"
