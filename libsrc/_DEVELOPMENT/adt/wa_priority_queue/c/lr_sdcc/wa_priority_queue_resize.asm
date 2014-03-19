
; int wa_priority_queue_resize(wa_priority_queue_t *q, size_t n)

XDEF wa_priority_queue_resize

wa_priority_queue_resize:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   push ix
   call asm_wa_priority_queue_resize
   pop ix
   
   ret
   
   INCLUDE "../../z80/asm_wa_priority_queue_resize.asm"
