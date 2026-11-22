
; int ba_priority_queue_pop(ba_priority_queue_t *q)

SECTION code_clib
SECTION code_adt_ba_priority_queue

PUBLIC _ba_priority_queue_pop

EXTERN _ba_priority_queue_pop_fastcall

_ba_priority_queue_pop:

   pop af
   pop hl
   
   push hl
   push af

   jp _ba_priority_queue_pop_fastcall
