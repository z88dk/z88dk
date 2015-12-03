
; void *ba_priority_queue_data_fastcall(ba_priority_queue_t *q)

SECTION code_clib
SECTION code_adt_ba_priority_queue

PUBLIC _ba_priority_queue_data_fastcall

EXTERN asm_ba_priority_queue_data

defc _ba_priority_queue_data_fastcall = asm_ba_priority_queue_data
