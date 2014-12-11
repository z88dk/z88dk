
; size_t bv_priority_queue_max_size(bv_priority_queue_t *q)

SECTION code_adt_bv_priority_queue

PUBLIC _bv_priority_queue_max_size

_bv_priority_queue_max_size:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_bv_priority_queue_max_size

   INCLUDE "adt/bv_priority_queue/z80/asm_bv_priority_queue_max_size.asm"
