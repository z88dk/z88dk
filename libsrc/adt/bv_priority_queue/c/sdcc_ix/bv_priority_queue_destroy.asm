
; void bv_priority_queue_destroy(bv_priority_queue_t *q)

SECTION code_clib
SECTION code_adt_bv_priority_queue

PUBLIC _bv_priority_queue_destroy

EXTERN asm_bv_priority_queue_destroy

_bv_priority_queue_destroy:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_bv_priority_queue_destroy
