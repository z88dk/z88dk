
; int ba_priority_queue_top(ba_priority_queue_t *q)

SECTION code_clib
SECTION code_adt_ba_priority_queue

PUBLIC _ba_priority_queue_top

EXTERN asm_ba_priority_queue_top

_ba_priority_queue_top:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_ba_priority_queue_top
