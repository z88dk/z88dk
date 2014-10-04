
; int wa_priority_queue_push(wa_priority_queue_t *q, void *item)

SECTION seg_code_wa_priority_queue

PUBLIC _wa_priority_queue_push

_wa_priority_queue_push:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
   
   INCLUDE "adt/wa_priority_queue/z80/asm_wa_priority_queue_push.asm"
