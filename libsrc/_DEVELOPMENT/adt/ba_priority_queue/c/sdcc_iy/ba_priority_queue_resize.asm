
; int ba_priority_queue_resize(ba_priority_queue_t *q, size_t n)

SECTION code_clib
SECTION code_adt_ba_priority_queue

PUBLIC _ba_priority_queue_resize

EXTERN asm_ba_priority_queue_resize

_ba_priority_queue_resize:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af

   jp asm_ba_priority_queue_resize
