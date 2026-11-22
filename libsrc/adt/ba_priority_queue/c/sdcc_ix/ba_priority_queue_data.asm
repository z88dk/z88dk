
; void *ba_priority_queue_data(ba_priority_queue_t *q)

SECTION code_clib
SECTION code_adt_ba_priority_queue

PUBLIC _ba_priority_queue_data

EXTERN asm_ba_priority_queue_data

_ba_priority_queue_data:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_ba_priority_queue_data
