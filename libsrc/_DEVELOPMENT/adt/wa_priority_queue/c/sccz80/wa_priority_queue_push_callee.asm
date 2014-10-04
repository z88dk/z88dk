
; int wa_priority_queue_push(wa_priority_queue_t *q, void *item)

SECTION seg_code_wa_priority_queue

PUBLIC wa_priority_queue_push_callee

wa_priority_queue_push_callee:

   pop hl
   pop bc
   ex (sp),hl
   
   INCLUDE "adt/wa_priority_queue/z80/asm_wa_priority_queue_push.asm"
