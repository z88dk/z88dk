
; int ba_priority_queue_push(ba_priority_queue_t *q, int c)

XDEF ba_priority_queue_push_callee

ba_priority_queue_push_callee:

   pop hl
   pop bc
   ex (sp),hl
   
   INCLUDE "../../z80/asm_ba_priority_queue_push.asm"
