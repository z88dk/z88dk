
; size_t p_queue_size_fastcall(p_queue_t *q)

SECTION code_clib
SECTION code_adt_p_queue

PUBLIC _p_queue_size_fastcall

EXTERN asm_p_queue_size

defc _p_queue_size_fastcall = asm_p_queue_size
