
; void *p_queue_pop_fastcall(p_queue_t *q)

SECTION code_clib
SECTION code_adt_p_queue

PUBLIC _p_queue_pop_fastcall

EXTERN asm_p_queue_pop

defc _p_queue_pop_fastcall = asm_p_queue_pop
