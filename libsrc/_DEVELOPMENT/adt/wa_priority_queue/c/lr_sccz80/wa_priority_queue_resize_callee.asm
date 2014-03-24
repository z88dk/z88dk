
; int wa_priority_queue_resize(wa_priority_queue_t *q, size_t n)

XDEF wa_priority_queue_resize_callee

wa_priority_queue_resize_callee:

   pop hl
   pop de
   ex (sp),hl
   
   INCLUDE "adt/wa_priority_queue/z80/asm_wa_priority_queue_resize.asm"
