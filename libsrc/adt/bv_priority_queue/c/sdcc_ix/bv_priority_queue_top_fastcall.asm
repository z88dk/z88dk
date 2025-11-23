
; int bv_priority_queue_top_fastcall(bv_priority_queue_t *q)

SECTION code_clib
SECTION code_adt_bv_priority_queue

PUBLIC _bv_priority_queue_top_fastcall

EXTERN asm_bv_priority_queue_top

defc _bv_priority_queue_top_fastcall = asm_bv_priority_queue_top
