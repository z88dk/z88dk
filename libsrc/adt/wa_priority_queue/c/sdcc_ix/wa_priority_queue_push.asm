
; int wa_priority_queue_push(wa_priority_queue_t *q, void *item)

SECTION code_clib
SECTION code_adt_wa_priority_queue

PUBLIC _wa_priority_queue_push

EXTERN l0_wa_priority_queue_push_callee

_wa_priority_queue_push:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af

   jp l0_wa_priority_queue_push_callee
