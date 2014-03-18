
; int ba_priority_queue_resize(ba_priority_queue_t *q, size_t n)

XDEF ba_priority_queue_resize

ba_priority_queue_resize:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   push ix
   call asm_ba_priority_queue_resize
   pop ix
   
   ret
   
   INCLUDE "../../z80/asm_ba_priority_queue_resize.asm"
