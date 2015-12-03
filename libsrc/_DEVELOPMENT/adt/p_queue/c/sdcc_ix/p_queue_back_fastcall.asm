
; void *p_queue_back_fastcall(p_queue_t *q)

SECTION code_clib
SECTION code_adt_p_queue

PUBLIC _p_queue_back_fastcall

EXTERN asm_p_queue_back

defc _p_queue_back_fastcall = asm_p_queue_back
