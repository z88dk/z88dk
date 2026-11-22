
; void *wa_priority_queue_top(wa_priority_queue_t *q)

SECTION code_clib
SECTION code_adt_wa_priority_queue

PUBLIC _wa_priority_queue_top

EXTERN asm_wa_priority_queue_top

_wa_priority_queue_top:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_wa_priority_queue_top
