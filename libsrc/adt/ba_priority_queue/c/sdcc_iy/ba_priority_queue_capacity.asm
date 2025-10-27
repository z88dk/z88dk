
; size_t ba_priority_queue_capacity(ba_priority_queue_t *q)

SECTION code_clib
SECTION code_adt_ba_priority_queue

PUBLIC _ba_priority_queue_capacity

EXTERN asm_ba_priority_queue_capacity

_ba_priority_queue_capacity:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_ba_priority_queue_capacity
