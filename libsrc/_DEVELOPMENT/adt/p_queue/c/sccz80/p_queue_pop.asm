
; void *p_queue_pop(p_queue_t *q)

SECTION code_clib
SECTION code_adt_p_queue

PUBLIC p_queue_pop

EXTERN asm_p_queue_pop

defc p_queue_pop = asm_p_queue_pop
