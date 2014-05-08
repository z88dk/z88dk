
; int ba_priority_queue_resize(ba_priority_queue_t *q, size_t n)

PUBLIC ba_priority_queue_resize_callee

ba_priority_queue_resize_callee:

   pop hl
   pop de
   ex (sp),hl
   
   INCLUDE "adt/ba_priority_queue/z80/asm_ba_priority_queue_resize.asm"
