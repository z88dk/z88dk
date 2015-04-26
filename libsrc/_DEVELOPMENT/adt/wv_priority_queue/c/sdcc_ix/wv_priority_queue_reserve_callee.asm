
; int wv_priority_queue_reserve_callee(wv_priority_queue_t *q, size_t n)

SECTION code_adt_wv_priority_queue

PUBLIC _wv_priority_queue_reserve_callee

_wv_priority_queue_reserve_callee:

   pop af
   pop hl
   pop bc
   push af
   
   INCLUDE "adt/wv_priority_queue/z80/asm_wv_priority_queue_reserve.asm"
