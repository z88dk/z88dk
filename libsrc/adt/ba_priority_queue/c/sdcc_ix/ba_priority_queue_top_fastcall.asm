
; int ba_priority_queue_top_fastcall(ba_priority_queue_t *q)

SECTION code_clib
SECTION code_adt_ba_priority_queue

PUBLIC _ba_priority_queue_top_fastcall

EXTERN asm_ba_priority_queue_top

defc _ba_priority_queue_top_fastcall = asm_ba_priority_queue_top
