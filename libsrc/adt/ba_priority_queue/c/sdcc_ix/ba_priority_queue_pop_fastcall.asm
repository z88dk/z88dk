
; int ba_priority_queue_pop_fastcall(ba_priority_queue_t *q)

SECTION code_clib
SECTION code_adt_ba_priority_queue

PUBLIC _ba_priority_queue_pop_fastcall

EXTERN asm_ba_priority_queue_pop

_ba_priority_queue_pop_fastcall:

   push ix
   
   call asm_ba_priority_queue_pop
   
   pop ix
   ret
