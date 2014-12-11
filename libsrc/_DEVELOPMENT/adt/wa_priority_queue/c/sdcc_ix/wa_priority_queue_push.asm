
; int wa_priority_queue_push(wa_priority_queue_t *q, void *item)

SECTION code_adt_wa_priority_queue

PUBLIC _wa_priority_queue_push

_wa_priority_queue_push:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
   
   push ix
   call asm_wa_priority_queue_push
   pop ix
   
   ret
   
   INCLUDE "adt/wa_priority_queue/z80/asm_wa_priority_queue_push.asm"
