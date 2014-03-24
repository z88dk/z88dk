
; int wv_priority_queue_reserve(wv_priority_queue_t *q, size_t n)

XDEF wv_priority_queue_reserve

wv_priority_queue_reserve:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   jp asm_wv_priority_queue_reserve
   
   INCLUDE "adt/wv_priority_queue/z80/asm_wv_priority_queue_reserve.asm"
