
; int wv_priority_queue_reserve(wv_priority_queue_t *q, size_t n)

SECTION seg_code_wv_priority_queue

PUBLIC _wv_priority_queue_reserve

_wv_priority_queue_reserve:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
   
   INCLUDE "adt/wv_priority_queue/z80/asm_wv_priority_queue_reserve.asm"
