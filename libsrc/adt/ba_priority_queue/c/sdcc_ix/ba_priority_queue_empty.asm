
; int ba_priority_queue_empty(ba_priority_queue_t *q)

SECTION code_clib
SECTION code_adt_ba_priority_queue

PUBLIC _ba_priority_queue_empty

EXTERN asm_ba_priority_queue_empty

_ba_priority_queue_empty:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_ba_priority_queue_empty
