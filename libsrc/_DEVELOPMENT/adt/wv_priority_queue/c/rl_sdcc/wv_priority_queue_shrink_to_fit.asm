
; int wv_priority_queue_shrink_to_fit(wv_priority_queue_t *q)

XDEF wv_priority_queue_shrink_to_fit

wv_priority_queue_shrink_to_fit:

   pop af
   pop hl
   
   push hl
   push af
   
   jp asm_wv_priority_queue_shrink_to_fit

   INCLUDE "adt/wv_priority_queue/z80/asm_wv_priority_queue_shrink_to_fit.asm"
