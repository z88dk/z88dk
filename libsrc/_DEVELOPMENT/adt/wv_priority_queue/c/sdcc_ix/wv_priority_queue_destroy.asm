
; void wv_priority_queue_destroy(wv_priority_queue_t *q)

XDEF wv_priority_queue_destroy

wv_priority_queue_destroy:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "adt/wv_priority_queue/z80/asm_wv_priority_queue_destroy.asm"
