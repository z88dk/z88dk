
; size_t wa_priority_queue_size(wa_priority_queue_t *q)

XDEF wa_priority_queue_size

wa_priority_queue_size:

   pop af
   pop hl
   
   push hl
   push af
   
   jp asm_wa_priority_queue_size

   INCLUDE "../../z80/asm_wa_priority_queue_size.asm"
