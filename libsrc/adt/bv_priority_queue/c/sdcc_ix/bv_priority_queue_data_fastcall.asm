
; void *bv_priority_queue_data_fastcall(bv_priority_queue_t *q)

SECTION code_clib
SECTION code_adt_bv_priority_queue

PUBLIC _bv_priority_queue_data_fastcall

EXTERN asm_bv_priority_queue_data

defc _bv_priority_queue_data_fastcall = asm_bv_priority_queue_data
