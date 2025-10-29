
; int ba_priority_queue_resize_callee(ba_priority_queue_t *q, size_t n)

SECTION code_clib
SECTION code_adt_ba_priority_queue

PUBLIC _ba_priority_queue_resize_callee

EXTERN asm_ba_priority_queue_resize

_ba_priority_queue_resize_callee:

   pop af
   pop hl
   pop de
   push af

   jp asm_ba_priority_queue_resize
