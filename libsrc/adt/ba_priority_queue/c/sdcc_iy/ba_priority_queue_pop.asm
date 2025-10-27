
; int ba_priority_queue_pop(ba_priority_queue_t *q)

SECTION code_clib
SECTION code_adt_ba_priority_queue

PUBLIC _ba_priority_queue_pop

EXTERN asm_ba_priority_queue_pop

_ba_priority_queue_pop:

   pop af
   pop hl
   
   push hl
   push af
   
   jp asm_ba_priority_queue_pop
