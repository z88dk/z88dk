
; size_t wv_priority_queue_max_size(wv_priority_queue_t *q)

XDEF wv_priority_queue_max_size

wv_priority_queue_max_size:

   pop af
   pop hl
   
   push hl
   push af
   
   jp asm_wv_priority_queue_max_size

   INCLUDE "../../z80/asm_wv_priority_queue_max_size.asm"
