
; int wv_priority_queue_shrink_to_fit(wv_priority_queue_t *q)

PUBLIC _wv_priority_queue_shrink_to_fit

_wv_priority_queue_shrink_to_fit:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "adt/wv_priority_queue/z80/asm_wv_priority_queue_shrink_to_fit.asm"
