
; size_t ba_priority_queue_size(ba_priority_queue_t *q)

SECTION code_clib
SECTION code_adt_ba_priority_queue

PUBLIC _ba_priority_queue_size

EXTERN asm_ba_priority_queue_size

_ba_priority_queue_size:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_ba_priority_queue_size
