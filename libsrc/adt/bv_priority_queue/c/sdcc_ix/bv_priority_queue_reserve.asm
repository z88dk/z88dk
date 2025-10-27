
; int bv_priority_queue_reserve(bv_priority_queue_t *q, size_t n)

SECTION code_clib
SECTION code_adt_bv_priority_queue

PUBLIC _bv_priority_queue_reserve

EXTERN asm_bv_priority_queue_reserve

_bv_priority_queue_reserve:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af

   jp asm_bv_priority_queue_reserve
