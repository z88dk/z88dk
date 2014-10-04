
; int ba_priority_queue_resize(ba_priority_queue_t *q, size_t n)

SECTION seg_code_ba_priority_queue

PUBLIC _ba_priority_queue_resize

_ba_priority_queue_resize:

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
   
   INCLUDE "adt/ba_priority_queue/z80/asm_ba_priority_queue_resize.asm"
