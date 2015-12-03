
; size_t bv_priority_queue_size_fastcall(bv_priority_queue_t *q)

SECTION code_clib
SECTION code_adt_bv_priority_queue

PUBLIC _bv_priority_queue_size_fastcall

EXTERN asm_bv_priority_queue_size

defc _bv_priority_queue_size = asm_bv_priority_queue_size
