
; int bv_priority_queue_reserve(bv_priority_queue_t *q, size_t n)

XDEF _bv_priority_queue_reserve

_bv_priority_queue_reserve:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af

   INCLUDE "adt/bv_priority_queue/z80/asm_bv_priority_queue_reserve.asm"
